-module(tcp_client).
-author('hbc 670762853@qq.com').
-behaviour(gen_server).
-include("common.hrl").
-include("login.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% @doc client contorl user bahaviour



-define(TIMEOUT, 6000).
-define(PH_LOGIN, ph_login).  %%登录逻辑模块
-define(PH_HANDLE, handle).   %%ph模块的通用处理函数名

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%----------------------------------------------------------------------
%% @doc Called by gen_server framework at process startup.
%% @end
%%----------------------------------------------------------------------
init([]) ->
	{ok, #state{}}.

%%-------------------------------------------------------------------------
%% @spec (Request, From, State) -> {reply, Reply, State}          |
%%                                 {reply, Reply, State, Timeout} |
%%                                 {noreply, State}               |
%%                                 {noreply, State, Timeout}      |
%%                                 {stop, Reason, Reply, State}   |
%%                                 {stop, Reason, State}
%% @doc Callback for synchronous server calls.  If `{stop, ...}' tuple
%%      is returned, the server is stopped and `terminate/2' is called.
%% @end
%% @private
handle_call(_Request, _From, State) ->
	{reply, ok, State}.

%%-------------------------------------------------------------------------
%% @spec (Msg, State) ->{noreply, State}          |
%%                      {noreply, State, Timeout} |
%%                      {stop, Reason, State}
%% @doc Callback for asyncrous server calls.  If `{stop, ...}' tuple
%%      is returned, the server is stopped and `terminate/2' is called.
%% @end
%% @private
%%-------------------------------------------------------------------------
handle_cast(_Msg, State) ->
	{noreply, State}.

%%-------------------------------------------------------------------------
%% @spec (Msg, State) ->{noreply, State}          |
%%                      {noreply, State, Timeout} |
%%                      {stop, Reason, State}
%% @doc Callback for messages sent directly to server's mailbox.
%%      If `{stop, ...}' tuple is returned, the server is stopped and
%%      `terminate/2' is called.
%% @end
%% @private
%%-------------------------------------------------------------------------
handle_info({lets_go, Socket}, State) ->
	case prim_inet:async_recv(Socket, 0, -1) of
		{ok		, NewRef} -> {noreply, State#state{acceptor = NewRef, socket = Socket}};
		{error	, Reason} -> {stop, Reason, State}
	end;
	
% handle_info({inet_async, Socket, Ref, {ok, <<Len:16, Cmd:16>>}}, State = #state{acceptor = Ref}) ->
% 	BodyLen = Len - ?HEADER_LEN,
% 	case prim_inet:async_recv(Socket, BodyLen, -1) of
% 		{ok	  , NewRef} -> {noreply, State#state{acceptor = NewRef, cmd = Cmd}};
% 		{error, Reason} -> {stop, Reason, State}
% 	end;

handle_info({inet_async, _Socket, _Ref, {ok, Binary}}, State = #state{pid = Pid}) ->
	case pack:pack(unpack, Binary) of
        undefined ->
            ?ERROR("accept pack data is undefined ~w",[Binary]),
            {stop, normal, State};
        {ModuleLogic, Record} when ModuleLogic =:= ?PH_LOGIN ->
            case erlang:apply(ModuleLogic, ?PH_HANDLE, [Record, State]) of
                Result = {stop, _, _} ->  Result;
                {noreply, NewState} ->    accept(NewState)
            end;
        {ModuleLogic, Record} ->
            Pid ! {rpc, ModuleLogic, ?PH_HANDLE, [Record]},
            accept(State)
    end;
			
handle_info({inet_async, _Socket, _Ref, {error, closed}}, State) ->
	io:format("closed ~n",[]),
	{stop, normal, State};

handle_info({inet_async, _Socket, _Ref, {error, timeout}}, State) ->
	io:format("timeout ~n",[]),
	{stop, timeout, State};

handle_info(_Info, State) ->
	{noreply, State}.

%%-------------------------------------------------------------------------
%% @spec (Reason, State) -> any
%% @doc  Callback executed on server shutdown. It is only invoked if
%%       `process_flag(trap_exit, true)' is set by the server process.
%%       The return value is ignored.
%% @end
%% @private
%%-------------------------------------------------------------------------
terminate(_Reason, _State) ->
	ok.

%%-------------------------------------------------------------------------
%% @spec (OldVsn, State, Extra) -> {ok, NewState}
%% @doc  Convert process state when code is changed.
%% @end
%% @private
%%-------------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

accept(State = #state{socket = Socket}) ->
    case prim_inet:async_recv(Socket, 0, -1) of
        {ok		, NewRef} -> {noreply, State#state{acceptor = NewRef}};
        {error  , Reason} -> {stop, Reason, State}
    end.

