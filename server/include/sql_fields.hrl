%% @author hbc 670762853@qq.com
%% @doc    一些需要用到的sql表的字段,这里的宏定义要和数据库表结构的定义一致,必须保持增删的同步
%% @end

-define(ROLE_FIELDS, "account, name, create_time, login_time, logout_time, level, sex, career, forbid_talk").
-define(ROLE_ASSETS, "exp, coin, gold, gold_acc").
-define(ROLE_MODS,   "pos, bag, fuben, task, hang").

