-module(ph_master).
-author('').
%% @doc 这里填写您的模块描述
%% @end
-include("master_pb.hrl").

-export([handle/2]).


handle(#request_master{}, State) ->
	{ignore, State};

handle(#request_master_one{}, State) ->
	{ignore, State};

handle(#request_master_two{}, State) ->
	{ignore, State};

handle(_, State) ->
	{ignore, State}.
