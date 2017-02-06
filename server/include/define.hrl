-include("id_type.hrl").
-include("sql_fields.hrl").

-define(TCP_OPTIONS, [binary,{packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, false}, {exit_on_close, true}]).
-define(DEFAULT_PORT, 6215).
-define(DB_POOL, mysql_pool).
-define(APPLICATION, np).
-define(PtNoLen, 16).

-define(INFO(Format), ?INFO(Format, [])).
-define(INFO(Format, Data), lager:info(Format, Data)).
-define(ERROR(Format), ?ERROR(Format, [])).
-define(ERROR(Format, Data), lager:error(Format, Data)).
-define(WARNING(Format), ?WARNING(Format,[])).
-define(WARNING(Format, Data), lager:warning(Format, Data)).

-define(TRUE(Value), Value =:= true).
-define(IF(C, A, B), case (C) of true -> A; false -> B end).

-define(OBJ_TYPE, 1).       %% 人物
-define(MONSTER_TYPE, 2).   %% 怪物
-define(PET_TYPE,   3).     %% 宠物

-define(CALL(Pid, Request), 
    case catch gen_server:call(Pid, Request) of
        {'EXIT', {timeout, _}} -> {error, timeout};
        {'EXIT', {noproc, _}} -> {error, noproc};
        {'EXIT', {Reason}} -> {error, Reason};
        Rtn -> Rtn
    end).
