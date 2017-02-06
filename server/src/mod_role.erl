-module(mod_role).
-author('hbc 670762853@qq.com').

-export([start/1, start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([stop/1, stop/2, apply/3, apply_after/3]).

-include("common.hrl").

%% @spec apply(async, Pid, MFA)-> Term
%% @type Pid = pid()
%% @type MFA = {M, F, A}
%% @TODO 方法的返回值 {ok} | {ok, NewState} 
apply(async, Pid, _mfa) when not is_pid(Pid) ->
    ?ERROR("mod_role apply async error, not_pid:~w, mfa:~w",[Pid, _mfa]),
    {error, not_pid};
apply(async, Pid, {F}) ->
    Pid ! {apply_async, {F}};
apply(async, Pid, {F, A}) ->
    Pid ! {apply_async, {F, A}};
apply(async, Pid, {M, F, A}) ->
    Pid ! {apply_async, M, F, A};

apply(sync, Pid, _MFA) when not is_pid(Pid) ->
    {error, not_pid};
apply(sync, Pid, _MFA) when self() =:= Pid ->
    ?ERROR("apply error, reason : self call ~w",[_MFA]),
    {error, self_call};
apply(sync, Pid, Term = {_}) ->
    ?CALL(Pid, {apply_async, Term});
apply(sync, Pid, Term = {_, _}) ->
    ?CALL(Pid, {apply_async, Term});
apply(sync, Pid, Term = {_, _, _}) ->
    ?CALL(Pid, {apply_async, Term}).

apply_after(Timeout, Pid, {M, F, A}) ->
    erlang:send_after(Timeout, Pid, {apply_async, {M, F, A}}).

%% @doc 同步停止Pid进程
stop(Pid) ->
    gen_server:call(Pid, stop).

%% @doc 异步停止Pid进程
stop(Pid, Reason) ->
    Pid ! {stop, Reason}.

start(Args) ->
    gen_server:start({local, ?MODULE}, ?MODULE, Args, []).
start_link(Args) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, Args, []).

init([RoleId, Account, Socket, TcpPid]) ->
    Pid = global:whereis_name(RoleId),
    case erlang:is_pid(Pid) andalso util:is_process_alive(Pid) of
        false ->
            global:re_register_name(RoleId, self()),
            case mod_sender:start_link([RoleId, Account, self(), Socket]) of
                {ok, SendPid} ->
                    lib_role_data:fetch(RoleId),
                    {ok, #obj{temp = #temp{send_pid = SendPid, tcp_pid = TcpPid}}};
                _Err ->
                    ?ERROR("mod_sender start error, reason ~w",[_Err]),
                    {stop, start_mod_sender_error}
            end;
        true ->
           stop(Pid, repeat_login),
           {stop, repeat_login}
    end.

handle_call({apply_sync, {F}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(F, [State]), {undefined, F, []}, State);
handle_call({apply_sync, {F, A}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(F, [State | A]), {undefined, F, A}, State);
handle_call({apply_sync, {M, F, A}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(M, F, [State | A]), {M, F, A}, State);

handle_call(stop, _From, State) ->
    {stop, normal, State};

handle_call(_Request, _From, State) ->
	{reply, ok, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info({rpc, M, F, A}, State) ->
    handle_apply_async_return(catch erlang:apply(M, F, A), {M, F, A}, State);

handle_info({apply_async, {F}}, State) ->
    handle_apply_async_return(catch erlang:apply(F, [State]), {undefined, F, []}, State);
handle_info({apply_async, {F, A}}, State) ->
    handle_apply_async_return(catch erlang:apply(F, [State | A]), {undefined, F, A}, State);
handle_info({apply_async, {M, F, A}}, State) ->
    handle_apply_async_return(catch erlang:apply(M, F, [State | A]), {M, F, A}, State);

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% @doc 处理apply异步的返回值
%% @end
handle_apply_async_return({ok}, _Mfa, State) -> 
    {noreply, State};
handle_apply_async_return({ok, NewState}, _Mfa, _State) ->
    {noreply, NewState};
handle_apply_async_return({sync, NewState}, _Mfa, _State) ->
    %%同步数据到缓存
    {noreply, NewState};
handle_apply_async_return(_Else, {_M, _F, _A}, State = #obj{base = #base{role_name = Name}}) ->
    ?ERROR("role [~s] apply_async {~w, ~w, ~w}, error return format ~w",[Name, _M, _F, _A, _Else]),
    {noreply, State}.
	
%% @doc 处理apply同步的返回值
%% @end
handle_apply_sync_return({ok, Reply, NewState}, _Mfa, _State) ->
    {reply, Reply, NewState};
handle_apply_sync_return({sync, Reply, NewState}, _Mfa, _State) ->
    %% 同步数据到缓存
    {reply, Reply, NewState};
handle_apply_sync_return(_Else, {_M, _F, _A}, State = #obj{base = #base{role_name = Name}}) ->
    ?ERROR("Role [~s] apply_sync {~w, ~w, ~w}, error return format ~w", [Name, _M, _F, _A, _Else]),
    {reply, ok, State}.
