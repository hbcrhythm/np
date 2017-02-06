-module(np_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	{ok, Pid} = np_sup:start_link(),
	case util:get_config(np, game_type, game) of
		game ->
            db:start(),
            websocket:start(),
			start(game);
		center ->
			start(center);
		rebot ->
			start(rebot)
	end,
	start(common),
	{ok, Pid}.

stop(_State) ->
    ok.

start(Type) ->
	[supervisor:start_child(np_sup, Child) || Child <- mod:mod(Type)].
