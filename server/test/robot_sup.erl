-module(robot_sup).
-author('hbc 670762853@qq.com').
-behaviour(supervisor).
-include("common.hrl").
-export([start_link/0, start_child/0]).
-export([init/1]).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
-define(MaxR, 5).
-define(MaxT, 30).

%% ===================================================================
%% API functions
%% ===================================================================
start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	{ok, {{simple_one_for_one, ?MaxR, ?MaxT}, 
		[
			{robot,
				{robot, start_link, []},
				temporary,
				2000,
				worker,
				[robot]
			}
		]}}.

start_child() ->
	supervisor:start_child(?MODULE, []).
