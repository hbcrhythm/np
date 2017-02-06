-module(np).
-author('hbc 670762853@qq.com').
-export([start/0]).

start() ->
	  start_applications([crypto, compiler, syntax_tools, goldrush, lager, emysql, protobuffs, ranch, cowlib, cowboy, np]).

start_applications(Apps) ->
    manage_applications(fun lists:foldl/3,
                        fun application:start/1, fun application:stop/1,
                        already_started, cannot_start_application, Apps).

manage_applications(Iterate, Do, Undo, SkipError,
                    ErrorTag, Apps) ->
    Iterate(fun (App, Acc) ->
                    case Do(App) of
                      ok -> [App | Acc];
                      {error, {SkipError, _}} -> Acc;
                      {error, Reason} ->
                          lists:foreach(Undo, Acc),
                          throw({error, {ErrorTag, App, Reason}})
                    end
            end,
            [], Apps),
    ok.
