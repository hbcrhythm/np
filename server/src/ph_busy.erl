-module(ph_busy).
-author('').
%% @doc 这里填写您的模块描述
%% @end
-include("busy_pb.hrl").

-export([handle/2]).


handle(#request_busy1{}, State) ->
	{ignore, State};

handle(#request_person_busy2{}, State) ->
	{ignore, State};

handle(#request_busy_jnl{}, State) ->
	{ignore, State};

handle(_, State) ->
	{ignore, State}.
