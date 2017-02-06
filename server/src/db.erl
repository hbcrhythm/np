-module(db).
-author('hbc 670762853@qq.com').
-include("common.hrl").
-include("emysql.hrl").

-export([execute/1]).

-export([start/0]).

start() ->
    Options     = util:get_config(?APPLICATION, mysql, []),
    emysql:add_pool(?DB_POOL, Options).


%% @spec execute(SqlPacket) -> NewSqlPacket
%% @type SqlPacket :: #sql_packet{}
%% @type NewSqlPacket :: #sql_packet{}
%% @type #sql_packet{
%%          sql             需要执行的sql语句,只处理列表或二进制
%%          ,result_rows    查询返回的结果集
%%          ,affected_rows  插入,更新,删除返回的受影响的行数
%%          ,code           错误码
%%          ,msg            消息
%%          ,as_record      undefined | #as_record{
%%                                              name 需要转换成的record name
%%                                              list 需要转换成的record fields info
%%                                          } 结果集需要转换成的record结构
%%      }
%% @doc  所有的sql请求必须经过此接口
%% @end
execute(SqlPacket = #sql_packet{sql = Sql}) when is_list(Sql) ->
    execute(SqlPacket#sql_packet{sql = list_to_binary(Sql)});
execute(SqlPacket = #sql_packet{sql = Sql, as_record = AsRecord}) when is_binary(Sql) andalso (AsRecord =:= undefined orelse is_record(AsRecord, as_record) ) ->
    case emysql:execute(?DB_POOL, Sql) of
        #result_packet{seq_num = Num, rows = Rows} when AsRecord =:= undefined ->
            SqlPacket#sql_packet{result_rows = Rows, seq_num = Num};
        Result = #result_packet{} when is_record(AsRecord, as_record) ->
            Recs = emysql:as_record(Result, AsRecord#as_record.name, AsRecord#as_record.list),
            SqlPacket#sql_packet{result_rows = Recs};
        #ok_packet{affected_rows = Rows, seq_num = Num, msg = Msg} ->
            SqlPacket#sql_packet{affected_rows = Rows, seq_num = Num, msg = Msg};
        #error_packet{seq_num = Num, code = Code, msg = Msg} ->
            SqlPacket#sql_packet{seq_num = Num, code = Code, msg = Msg}
    end;
execute(_SqlPacket) -> #sql_packet{msg = "unknown sql packet"} .
    

    

    

            

