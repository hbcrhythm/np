%% ----------------------------------------
%% @author hbc 670762853@qq.com
%% @doc 游戏中数据库操作属性 
%% ----------------------------------------

-record(as_record,{
    name
    ,list
    }).

%% @doc sql语句处理包，调用sql。
-record(sql_packet,{
    sql
    ,result_rows
    ,affected_rows
    ,seq_num
    ,code
    ,msg
    ,as_record
   }).