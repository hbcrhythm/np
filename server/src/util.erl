-module(util).
-author('hbc 670762853@qq.com').

-include("common.hrl").

-export([get_config/3]). 

-export([unixtime/0 
         ,unixtime/1
         ,ceil/1
         ,floor/1 
         ,bitstring_to_term/1
         ,term_to_string/1
         ,term_to_bitstring/1
         ,cn/1
         ,md5/1
         ,f2s/1
         ,to_binary/1
         ,to_integer/1
         ,to_atom/1
         ,to_list/1
         ,is_process_alive/1
        ]).

%% @spec get_config(App, Key, DVal) -> Value | DVal
%% @doc 获取应用的配置参数 e.g : get_config(?APPLICAITON, port, 6215)
%% @type App :: atom()
%% @type key :: atom()
%% @type DVal:: Term | String | int() | atom()
get_config(App, Key, DVal) ->
	case application:get_env(App, Key) of
		{ok, Value} -> Value;
		undefined -> DVal
	end.


%% @spec unixtime() -> int()
%% @doc 取当前unix时间戳
unixtime() ->
    {M, S, _} = os:timestamp(),
    M * 1000000 + S.

%% @spec unixtime(today) -> int()
%% @doc 获取当前0时0分0秒的时间戳
unixtime(today) ->
    {M, S, MS} = os:timestamp(),
    {_, Time} = calendar:now_to_local_time({M, S, MS}),
    M * 1000000 + S - calendar:time_to_seconds(Time);

%% @spec unixtime({today, Unixtime}) -> int()
%% @doc  获取某时间戳凌晨的时间戳
unixtime({today, Unixtime}) ->
    Base = unixtime(today),
    case Unixtime > Base of
        true -> (Unixtime - Base) div 86400 * 86400 + Base;
        false -> Base - ceil((Base - Unixtime) / 86400) * 86400
    end.

%% @spec ceil(I) -> int()
%% @doc  向上取整
ceil(I) ->
    case I =:= trunc(I) of
        true    -> I;
        false   -> I + 1
    end.

%% @spec floor(I) -> int()
%% @doc  向下取整
floor(I) ->
    case I =:= trunc(I) of
        true    -> I;
        false   -> I - 1
    end.

%% @spec term_to_string(Term) -> "Term"
%% term序列化, term转换为bitstring, e.g : [{a}, 1] => "[{a}, 1]"
term_to_string(Term) ->
    binary_to_list(list_to_binary(io_lib:format("~p", [Term]))).

%% @spec term_to_bitstring(Term) -> <<"Term">>
%% @doc term 反序列化,term转换为bitstring 格式 e.g : [{a}, 1] => <<"[{a}, 1]">>
term_to_bitstring(Term) ->
    erlang:list_to_bitstring(io_lib:format("~p", [Term])).

%% @spec bitstring_to_term(String::list()) -> {error, Why::term()} | {ok, term()}
%% @doc bitstring 转换为term
bitstring_to_term(undefined) -> {ok, undefined};
bitstring_to_term(BitString) -> string_to_term(binary_to_list(BitString)).

%% @spec string_to_term(String::list()) -> {error, Why::term()} | {ok, term}
%% @doc  term 反里序列,string转换为Term, e.g : "[{a}, 1]" => [{a},1]
string_to_term(String) ->
    case erl_scan:string(String ++ ".") of
        {ok, Tokens, _} -> erl_parse:parse_term(Tokens);
        {error, Err, _} -> {error, Err};
        Err             -> {error, Err}
    end.


%% @spec cn(String) -> ok
%% @doc  输出Str
cn(Str) ->
    cn(Str, []).
cn(Str, A) ->
    io:format("~ts", [iolist_to_binary(io_lib:format(Str, A))]).

%% @spec md5 -> list()
%% @doc 将二进制的MD5转换成16进制的格式
%% @end
md5(Bin) ->
    lists:flatten([io_lib:format("~2.16.0b", [N]) || N <- binary_to_list(Bin)]).

%% @spec f2s(1.5678) -> 1.57
%% @doc convert float/integer to string 
%% @end
f2s(N) when is_integer(N) ->
    integer_to_list(N) ++ ".00";
f2s(N) when is_list(N) ->
    [A] = io_lib:format("~.2f", [N]),
    A.

%% @spec to_binary(Msg) -> binary()
%% @doc  convert Msg to binary
%%       对于不确定的Msg操作的时候要加catch
%% @end
to_binary(Msg) when is_binary(Msg) ->
    Msg;
to_binary(Msg) when is_atom(Msg) ->
    list_to_binary(atom_to_list(Msg));
to_binary(Msg) when is_list(Msg) ->
    list_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) ->
    list_to_binary(integer_to_list(Msg));
to_binary(Msg) when is_float(Msg) ->
    list_to_binary(f2s(Msg));
to_binary(Msg) when is_tuple(Msg) ->
    list_to_binary(tuple_to_list(Msg));
to_binary(_Msg) -> throw(other_value).

%% @soec to_integer(Msg) -> integer()
%% @doc convert Msg to integer
%% @end
to_integer(Msg) when is_integer(Msg) ->
    Msg;
to_integer(Msg) when is_binary(Msg) ->
    Msg2 = binary_to_list(Msg),
    list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) ->
    list_to_integer(Msg);
to_integer(Msg) when is_float(Msg) ->
    round(Msg);
to_integer(_Msg) -> throw(other_value).
    
%% @spec to_atom(Msg) -> atom()
%% @doc convert Msg to atom
%% @end
to_atom(Msg) when is_atom(Msg) ->
    Msg;
to_atom(Msg) when is_binary(Msg) ->
    list_to_atom2(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) ->
    list_to_atom2(Msg);
to_atom(_) -> throw(other_value).

list_to_atom2(List) when is_list(List) ->
    case catch(list_to_existing_atom(List)) of
        {'EXIT', _} -> erlang:list_to_atom(List);
        Atom when is_atom(Atom) -> Atom
    end.

%% @spec to_list(Msg) -> list()
%% @doc convert Msg to list
%% @end
to_list(Msg) when is_list(Msg) ->
    Msg;
to_list(Msg) when is_atom(Msg) ->
    atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) ->
    binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) ->
    integer_to_list(Msg);
to_list(Msg) when is_float(Msg) ->
    f2s(Msg);
to_list(Msg) when is_tuple(Msg) ->
    tuple_to_list(Msg);
to_list(_) -> throw(other_value).

%% @spec is_process_alive(Pid) -> true | false
%% @doc  检测进程是否存活
%% @end
is_process_alive(Pid) when is_pid(Pid) ->
    case node() =:= node(Pid) of
        true ->
            erlang:is_process_alive(Pid);
        false ->
            case rpc:call(node(Pid), erlang, is_process_alive, [Pid]) of
                true -> true;
                false -> false;
                _ -> false
            end
    end.
