-module(ws_handle).
-author('hbc 670762853@qq.com').
%% @doc websocket处理模块

-include("common.hrl").
-export([
		init/3,
		websocket_init/3,
		websocket_handle/3,
		websocket_info/3,
		websocket_terminate/3
	]).

-record(config, {heartbeat,
  heartbeat_timeout,
  session_timeout,
  callback,
  protocol,
  opts
}).

-record(http_state, {action, config = #config{},
  session_id, heartbeat_tref, pid = undefined}).

-define(PH_LOGIN, ph_login).  %%登录逻辑模块
-define(PH_HANDLE, handle).   %%ph模块的通用处理函数名

init({_, http}, Req, _) ->
	% {Method, _} = cowboy_req:method(Req),
	% {PathInfo, _} = cowboy_req:path_info(Req),
	{upgrade, protocol, cowboy_websocket}.

% init_by_method(_Method, [<<"websocket">>, _Sid], _Config, Req) ->
%   lager:info("upgrade~n", []),
%   {upgrade, protocol, cowboy_websocket};

% init_by_method(_Method, _PathInfo, Config, Req) ->
%   {ok, Req, #http_state{config = Config}}.

websocket_init(_TransportName, Req, State) ->
  % {PathInfo, _} = cowboy_req:path_info(Req),
  % [<<"websocket">>, _Sid] = PathInfo,
  % self() ! post_init,
  {ok, Req, State}.

websocket_handle({binary, Binary}, Req, State) ->
  case pack:pack(unpack, Binary) of
        undefined ->
            ?ERROR("accept pack data is undefined ~w",[Binary]),
            {stop, normal, State};
        {ModuleLogic, Record} when ModuleLogic =:= ?PH_LOGIN ->
            lager:info("common in ~w",[Record]);
            % case erlang:apply(ModuleLogic, ?PH_HANDLE, [Record, State]) of
            %     Result = {stop, _, _} ->  Result;
            %     {noreply, NewState} ->    accept(NewState)
            % end;
        {ModuleLogic, Record} ->
            % Pid ! {rpc, ModuleLogic, ?PH_HANDLE, [Record]},
            % accept(State)
            lager:info("common in11 ~w",[Record])
  end,
  {reply, {binary, Binary}, Req, State};

websocket_handle(Data, Req, State) ->
  lager:error("unknow send from client~p~n", [Data]),
  {ok, Req, State}.


%% session process DOWN because we monitor before
websocket_info({'DOWN', _Ref, process, Pid, _Reason}, Req, State = {_Config, Pid}) ->
  {shutdown, Req, State};

websocket_info(Info, Req, State) ->
  lager:info("unknow wesocket_info~p~n", [?MODULE, Info]),
  {ok, Req, State}.


websocket_terminate(Reason, _Req, {_Config, Pid}) ->
  lager:info("recon_web_handler1 terminate: Reason~p~n", [Reason]),
  recon_web_session:disconnect(Pid),
  ok;
websocket_terminate(Reason, _Req, State) ->
  lager:info("recon_web_handler2 terminate: Reason~p~n, State~p~n", [Reason, State]),
  ok.