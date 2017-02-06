-module(tcp_listener).
-author('670762853@qq.com').
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {listen, acceptor}).

-include("common.hrl").

%%--------------------------------------------------------------------
%% @spec (Port::integer(), Module) -> {ok, Pid} | {error, Reason}
%
%% @doc Called by a supervisor to start the listening process.
%% @end
%%----------------------------------------------------------------------
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [util:get_config(np, port, ?DEFAULT_PORT)], []).

%%%------------------------------------------------------------------------
%%% Callback functions from gen_server
%%%------------------------------------------------------------------------
 

%%----------------------------------------------------------------------
%% @spec (Port::integer()) -> {ok, State}           |
%%                            {ok, State, Timeout}  |
%%                            ignore                |
%%                            {stop, Reason}
%%
%% @doc Called by gen_server framework at process startup.
%%      Create listening socket.
%% @end
%%----------------------------------------------------------------------
init([Port]) ->
	process_flag(trap_exit, true),
	case gen_tcp:listen(Port, ?TCP_OPTIONS) of
		{ok, ListenSocket} ->
			{ok, Ref} = prim_inet:async_accept(ListenSocket, -1),
			{ok, #state{listen = ListenSocket, acceptor = Ref}};
		{error, Reason} ->
			{stop, Reason}
	end.


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
handle_info({inet_async, ListenSocket, Ref, {ok, ClientSocket}}, State = #state{listen = ListenSocket, acceptor = Ref}) ->
	io:format("enter client socket ~w",[ListenSocket]),
	try 
		case set_sockopt(ListenSocket, ClientSocket) of
			ok -> ok;
			{error, Reason} -> exit({set_sockopt, Reason})
		end,
		{ok, Pid} = tcp_client_sup:start_child(),
		gen_tcp:controlling_process(ClientSocket, Pid),
		Pid ! {lets_go, ClientSocket},
		case prim_inet:async_accept(ListenSocket, -1) of
			{ok, 	NewRef} -> {noreply, State#state{acceptor = NewRef}};
			{error, NewRef} -> exit({async_accept, inet:format(NewRef)})
		end
	catch exit:Why ->
		{stop, Why, State}
	end;

handle_info({inet_async, _ClientSocket, Ref, Error}, State = #state{acceptor = Ref}) ->
	{stop, Error, State};

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

set_sockopt(ListenSocket, ClientSocket) ->
	true = inet_db:register_socket(ClientSocket, inet_tcp),
	case prim_inet:getopts(ListenSocket, [active, nodelay, keepalive, delay_send, priority, tos]) of
		{ok, Opts} ->
			case prim_inet:setopts(ClientSocket, [{packet, 0} | Opts]) of
				ok -> ok;
				Error -> gen_tcp:close(ClientSocket), Error
			end;
		Error ->
			gen_tcp:close(ClientSocket), Error
	end.

