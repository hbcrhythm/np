%%----------------------------------------------------
%% @doc 机器人进程
%% @end
%%----------------------------------------------------
-module(robot).
-author('hbc 670762853@qq.com').
-behaviour(gen_server).
-include("common.hrl").
-include("login_pb.hrl").
-include("robot.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    Port = util:get_config(?APPLICATION, port, ?DEFAULT_PORT),
    Ip   = util:get_config(?APPLICATION, ip, "127.0.0.1"),
    {ok, Socket} = gen_tcp:connect(Ip, Port, lists:keyreplace(packet, 1, ?TCP_OPTIONS, {packet, 2})),
    {SPid, _} = erlang:spawn_monitor(fun() -> lib_robot:start_send() end),
    {RPid, _} = erlang:spawn_monitor(fun() -> lib_robot:start_receive() end),
    {ok, #robot{socket = Socket, send_pid = SPid, receive_pid = RPid}, 0}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(timeout, State) ->
    {ok, NewState} = lib_robot_logic:send(#request_login{}, State),
    {noreply, NewState};

handle_info({rpc, Record}, State) ->
    case catch ph_robot:handle(Record, State) of
        {'EXIT', Reason} ->
            ?ERROR("ph_robot erorr, Record: ~w, Reason: ~w",[Record, Reason]),
            {noreply, State};
        {ok, NewState} ->
            {noreply, NewState}
    end;

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


