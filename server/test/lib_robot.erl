-module(lib_robot).
-author('hbc 670762853@qq.com').

-include("common.hrl").

-export([start_send/2, start_receive/2]).

start_send(Socket, ParentPid) ->
    receive
        {send_bin, Bin} ->
            erlang:port_command(Socket, Bin, [force]);
        Msg ->
            ?ERROR("unknow msg ~w",[Msg])
    end,
    start_send(Socket, ParentPid).

start_receive(Socket, ParentPid) ->
    prim_inet:async_recv(Socket, 0, -1),
    receive
        {inet_async, Socket, _Ref, {ok, Binary}} ->
            {_, Record} = pack:pack(unpack2, Binary), 
            ParentPid ! {rpc, Record};
        {inet_async, Socket, _Ref, {error, closed}} ->
            ?ERROR("target has close ~n",[]),
            exit(self(), normal);
        {inet_async, Socket, _Ref, {error, timeout}} ->
            ?ERROR("unknow why timeout ~n",[]),
            exit(self(), timeout)
    end,
    start_receive(Socket, ParentPid).
