-module(ph_common).
-author('').
%% @doc 这里填写您的模块描述
%% @end
-include("common_pb.hrl").

-export([handle/2]).


handle(_, State) ->
	{ignore, State}.
