-record(robot_base, {
    account
    ,id
    ,name
    ,career
    ,sex
    ,level
    }).

-record(robot, {
    socket
    ,send_pid
    ,receive_pid
    ,robot_base = #robot_base{}
    }).


-define(account, "hbc").
