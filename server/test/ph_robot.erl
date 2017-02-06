-module(ph_robot).
-author('hbc 670762853@qq.com').
-include("common.hrl").
-include("login_pb.hrl").
-include("robot.hrl").

-export([handle/2]).

handle(#return_login{list = Roles}, State = #robot{robot_base = RobotBase = #robot_base{account = Account}}) ->
    ?INFO("return login, roles: ~w",[Roles]),
    case Roles of
        [] ->
            lib_robot_logic:send(#request_create{name = Account, career = 1, sex = 1}),
            {ok, State#robot{robot_base = RobotBase#robot_base{name = Account, career = 1, sex = 1}}};
        [#roles{role_id = RoleId, career = Career, sex = Sex, level = Level, role_name = Name} | _] ->
            ?INFO("lib_robot_logic, send role enter ~w",[RoleId]),
            lib_robot_logic:send(#request_enter{role_id = RoleId}),
            {ok, State#robot{robot_base = RobotBase#robot_base{name = Name, career = Career, sex = Sex, id = RoleId, level = Level}}}
    end;

     
handle(_Msg, State) ->
    {ok, State}.

