%%----------------------------------------------------
%% @doc 机器人管理模块
%% @end
%%----------------------------------------------------
-module(robot_manager).
-author('hbc 670762853@qq.com').
-behaviour(gen_server).
-include("common.hrl").
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([offline/0, lookup/0]).

-record(state, {online_num = 0, offline_num = 0, surplus = 0}).
-define(DEFAULT_ROBOT_NUM, 10).
-define(INTERVAL, 5).

offline() ->
    ?MODULE ! {del}.

lookup() ->
    ?MODULE ! {lookup}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Num = util:get_config(?APPLICATION, robot_num, ?DEFAULT_ROBOT_NUM),
    State = #state{surplus = Num},
    {ok, State, 0}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(timeout, State = #state{online_num = OnlineNum, surplus = Surplus}) ->
    erlang:send_after(?INTERVAL * 1000, self(), timeout),
    robot_sup:start_child(),
    {noreply, State#state{online_num = OnlineNum + 1, surplus = Surplus - 1}};

handle_info({del}, State = #state{offline_num = OfflineNum}) ->
    {noreply, State#state{offline_num = OfflineNum + 1}};

handle_info({lookup}, State) ->
    [_H| T] = record_info(fields, state),
    List = [{Field, element(Field, State)} || Field <- T],
    ?ERROR("lookup robot manager info ~w",[List]),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

