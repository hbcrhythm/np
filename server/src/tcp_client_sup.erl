-module(tcp_client_sup).
-author('670762853@qq.com').
-behaviour(supervisor).

%% External API
-export([start_link/0, start_child/0]).

%% gen_server callbacks
-export([init/1]).

-define(MaxR, 5).
-define(MaxT, 30).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	{ok, {{simple_one_for_one, ?MaxR, ?MaxT}, 
		[
			{tcp_client,
				{tcp_client, start_link, []},
				temporary,
				2000,
				worker,
				[tcp_client]
			}
		]}}.

start_child() ->
	supervisor:start_child(?MODULE, []).
