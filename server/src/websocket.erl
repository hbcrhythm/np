-module(websocket).
-author('hbc 670762853@qq.com').
%% @doc websocket辅助模块
-include("common.hrl").
-export([start/0]).

start() ->
	Dispatch = cowboy_router:compile([
    {'_', [
      {"/", ws_main_handle, []},
      {"/ws/[...]", ws_handle, []}
    	]}
    ]),
  	NetWorks = [{port, util:get_config(np, port, ?DEFAULT_PORT)}],
  	{ok, _T} = cowboy:start_http(recon_web_http, 20, NetWorks, [{env, [{dispatch, Dispatch}]}]).
