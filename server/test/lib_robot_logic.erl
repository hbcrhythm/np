-module(lib_robot_logic).
-author('hbc 670762853@qq.com').

-include("common.hrl").
-include("robot.hrl").
-include("login_pb.hrl").

-export([send/2]).

send(#request_login{}, State = #robot{send_pid = SPid, robot_base = RobotBase}) ->
    Account = lists:concat([?account, random:uniform(util:unixtime())]),
    Bin = erlang:iolist_to_binary(login_pb:encode([#request_login{
                                                      account = Account,
                                                      timestamp = util:unixtime(),
                                                      sign = 0,
                                                      platform_id = 0,
                                                      device_no = 1,
                                                      channel_id = 1,
                                                      version = 0,
                                                      ext = []}])),
    SPid ! {send_bin, Bin},
    {ok, State#robot{robot_base = RobotBase#robot_base{account = Account}}};

send(_Msg, State) ->
    ?ERROR("unknow send msg, _Msg: ~w",[_Msg]),
    {ok, State}.


