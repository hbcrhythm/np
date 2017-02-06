-module(lib_name).
-author('hbc 670762853@qq.com').
%% @doc 名字检测模块
%% @end
-include("common.hrl").
-export([check/1]).

%% @sepc check(CheckName = #check_name{args = Args}) -> true | {false, ErrCode}
%% @type Args :: list() 本次名字检测需要执行的check case
%%       e.g  :  check(#check_name{name = "黄保城", min_len = 4, max_len = 16, args = [len, verify]})
%% @doc  名字检测函数
%% @end
check(CheckName = #check_name{name = Name}) when is_binary(Name) ->
    check(CheckName#check_name{name = util:to_list(Name)});
check(CheckName = #check_name{name = Name, args = Args}) when is_list(Name) ->
    F = fun Check([])       -> true;
            Check([H| T])   -> ?TRUE(check(H, CheckName)) andalso Check(T)
    end,
    F(Args).

check(len, #check_name{name = Name, min_len = MinLen, max_len = MaxLen}) ->
   List = unicode:characters_to_list(Name),
   F = fun(Term, Acc) when Term > 255 -> Acc + 2;
          (_, Acc) -> Acc + 1
   end,
   Count = lists:foldl(F, 0, List),
   ?IF(Count =< MinLen, {false, ?ERR_NAME_IS_TOO_SHORT}, ?IF(Count >= MaxLen, {false, ?ERR_NAME_IS_TOO_LONG}, true));

check(verify, #check_name{name = Name}) ->
    List = unicode:characters_to_list(Name),
    F    = fun Verify(8226) -> false;
               Verify(Ascii) when Ascii < 48 -> false;
               Verify(Ascii) when Ascii > 57 andalso Ascii < 65 -> false;
               Verify(Ascii) when Ascii > 90 andalso Ascii < 97 -> false;
               Verify(Ascii) when Ascii > 122 andalso Ascii < 128 -> false;
               Verify([]) -> true;
               Verify([_H | T]) ->  Verify(T)
    end,
    F(List) orelse {false, ?ERR_NAME_IS_NOT_VERIFY};

check(no_exist, #check_name{sql = Sql}) ->
    %Sql = io_lib:format("select account_id from account where account_name = ~w",[util:to_binary(Name)]),
    case db:execute(#sql_packet{sql = Sql}) of
        #sql_packet{result_rows = []}  -> true;
        #sql_packet{result_rows = _Rows, code = undefined} -> {false, ?ERR_NAME_IS_USED};
        #sql_packet{code = _Code, msg = _Msg} ->
            ?ERROR("check error sql_packet, code: ~w, msg: ~s",[_Code, _Msg]),
            {false, ?ERR_NAME_IS_USED}
    end.


