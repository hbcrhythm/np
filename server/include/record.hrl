-include("assets.hrl").
-include("sql_packet.hrl").

%% @doc 存放对象基本信息,这张表和role表对应
-record(base,{
        account             %% 账号
        ,role_name          %% 对象名字
        ,create_time = 0    %% 创建时间
        ,login_time  = 0    %% 登路时间
        ,logout_time = 0    %% 登出时间
        ,level = 0          %% 等级
        ,career = 0         %% 职业
        ,sex = 0            %% 性别
        ,vip = 0            %% vip等级
        ,forbid_task = 0    %% 禁言结束时间戳
        }).

%% @doc 存放对象位置信息
-record(pos,{
        map_id = 0          %% 地图id
        ,x     = 0          %% 对象X坐标
        ,y     = 0          %% 对象Y坐标
        ,dir   = 0          %% 对象朝向
        ,last  = {0,0,0,0}  %% {MapId, X, Y, Dir}
        }).

%% @doc 下线数据不保存
-record(temp,{
        pid                 %% 对象进程pid
        ,tcp_pid
        ,send_pid
        ,map_pid            %% 对象锁在地图pid
        ,fight_pid          %% 对象战斗进程pid
    }).

-record(mods,{
        pos  = #pos{}       %% 对象位置信息
        ,bag                %% 对象背包信息
        ,fuben              %% 副本信息
        ,task               %% 任务信息
        ,hang               %% 挂机信息
    }).

%% @doc 包括游戏中对象的所有属性
-record(obj,{
        id
        ,type                   %% 对象的类型, 1人物, 2怪物, 3宠物
        ,base     = #base{}     %% 对象基础信息
        ,assets   = #assets{}   %% 对象资产信息
        ,mods     = #mods{}     %% 对象模块信息
        ,temp     = #temp{}     %% 对象在线临时信息
       }).

-record(check_name, {
        name
        ,min_len = 4
        ,max_len = 16
        ,sql
        ,args
      }).
