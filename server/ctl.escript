#!/usr/bin/env escript
%% -*- erlang -*-
%%! -noshell -noinput
%% Have issue send mail to '670762853@qq.com'
%% The author Mr Huang

-define(EBIN_FILE, "ebin/np.app").

main(["no_args_option", M, F]) ->
    TargetNode = common_option(),
    Result = rpc:call(TargetNode, erlang:list_to_atom(M), erlang:list_to_atom(F), []),
    io:format("no_args_option result : ~w",[Result]),
    halt();

main(["atom_args_option", M, F | Args]) ->
    TargetNode = common_option(),
    AtomArgs = [erlang:list_to_atom(Arg) || Arg <- Args],
    Result = rpc:call(TargetNode, erlang:list_to_atom(M), erlang:list_to_atom(F), [AtomArgs]),
    io:format("atom_args_option result : ~w",[Result]),
    halt();

main(["string_args_option", M, F | Args]) ->
    TargetNode = common_option(),
    Result = rpc:call(TargetNode, erlang:list_to_atom(M), erlang:list_to_atom(F), [Args]),
    io:format("string_args_option result : ~w",[Result]),
    halt().

common_option() ->
    {ok, BitString} = file:read_file(?EBIN_FILE),
    String = binary_to_list(BitString),
    {ok, {_, _, TermList}} = case erl_scan:string(String) of
        {ok, Tokens, _} -> erl_parse:parse_term(Tokens);
        {error, _Err, _} -> 
            io:format("line ~w Err ~w",[?LINE, _Err]),
            init:stop(1);
        _Err             -> 
            io:format("line ~w Err ~w",[?LINE, _Err]),
            init:stop(1)
    end,
    EnvList      = proplists:get_value(env, TermList), 
    AgentName    = proplists:get_value(agent_name, EnvList),
    GameName     = proplists:get_value(game_name, EnvList),
    ServerId     = proplists:get_value(server_id, EnvList),
    Ip           = proplists:get_value(ip, EnvList),
    Cookie       = proplists:get_value(cookie, EnvList),
    TargetNode   = erlang:list_to_atom(lists:concat([AgentName, "_", GameName, "_", ServerId, "@", Ip])),
    net_kernel:start([erlang:list_to_atom(lists:concat([AgentName, "_", GameName, "_", ServerId, "_", "ctl", "@", Ip])), longnames]),
    erlang:set_cookie(node(), erlang:list_to_atom(Cookie)),
    %%io:format("AgentName ~w, GameName ~w, ServerId ~w, Node ~s ping ~w",[AgentName, GameName, ServerId, TargetNode, net_adm:ping(TargetNode)]),
    TargetNode.
