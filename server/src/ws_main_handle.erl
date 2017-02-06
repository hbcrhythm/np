-module(ws_main_handle).
-author('hbc 670762853@qq.com').
%% @doc websocket处理模块

-include("common.hrl").
-export([
		init/3,
		handle/2,
		terminate/3
	]).

-define(PH_LOGIN, ph_login).  %%登录逻辑模块
-define(PH_HANDLE, handle).   %%ph模块的通用处理函数名

init(_, Req, State) ->
	case cowboy_req:header(<<"origin">>, Req) of
		{undefined, Req1} -> {ok, Req1, State};
		{Origin, Req1} ->
			Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>,
                                              Origin, Req1),
            Req3 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>,
                                              <<"POST, OPTIONS">>, Req2),
            Req4 = cowboy_req:set_resp_header(
                     <<"access-control-allow-credentials">>, <<"true">>, Req3),
            Req5 = cowboy_req:set_resp_header(
                     <<"access-control-allow-headers">>, <<"authorization,content-type">>, Req4),
            {ok, Req5, State}
    end.

handle(Req, State) ->
	{Method, Req2} = cowboy_req:method(Req),
	to_handle(Method, Req2, State).

to_handle(<<"POST">>, Req, State) ->
	{ok, PostVals, Req2} = cowboy_req:body_qs(Req),
	Echo = proplists:get_value(<<"name">>, PostVals),
	{ok,   Req7} = cowboy_req:reply(200, [
		{<<"content-type">>, <<"text/plain; charset=utf-8">>}
	], Echo, Req2),
	{ok, Req7, State};

to_handle(<<"GET">>, Req, State) ->
	{Echo, Req2} = cowboy_req:qs_val(<<"name">>, Req),
	{ok,   Req7} = cowboy_req:reply(200, [
		{<<"content-type">>, <<"text/plain; charset=utf-8">>}
	], jsx:encode([{<<"library">>,<<"jsx">>},{<<"awesome">>,true}]), Req2),
	{ok, Req7, State}.

terminate(_Reason, _Req, _State) ->
	ok.
