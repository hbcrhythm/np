-module(mod).

-export([mod/1]).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

mod(common) -> [];

mod(game) -> [
             	% ?CHILD(tcp_client_sup, supervisor),
                % ?CHILD(tcp_listener, worker)
             ];

mod(center) -> [];

mod(rebot) -> [?CHILD(robot_sup, supervisor)].


