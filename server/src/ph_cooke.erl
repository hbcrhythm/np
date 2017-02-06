-module(ph_cooke).
-author('').
%% @doc 这里填写您的模块描述
%% @end
-include("cooke_pb.hrl").

-export([handle/2]).


handle(#request_hehe{}, State) ->
	{ignore, State};

handle(#request_ioio{}, State) ->
	{ignore, State};

handle(#request_jujuij{}, State) ->
	{ignore, State};

handle(_, State) ->
	{ignore, State}.
