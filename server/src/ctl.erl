-module(ctl).
-author('hbc 670762853@qq.com').
-include("common.hrl").

-export([reload/1]).

%% @spec reload(M) -> void() | term()
%% @doc 重新加载模块
reload(M) when is_atom(M) ->
    c:l(M);
reload(M) when is_list(M) ->
    [c:l(Module) || Module <- M] .
    

