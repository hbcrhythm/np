-module(ph_login).
-author('hbc 67076285@qq.com').
%% @doc 登录逻辑模块处理,本进程非角色进程.属于client socket进程
%% @end
-include("common.hrl").
-include("login_pb.hrl").
-include("login.hrl").

-define(VERIFY_STATUS, 0).%% 验证状态,验证还未通过。
-define(WAIT_STATUS, 1).  %% 等待状态,客户端可以选择角色,并发起进入场景协议。

-export([handle/2]).


handle(Record = #request_login{account = Account}, State) ->
    case lib_login:verify(Record) of
        true ->
            case lib_login:exist(Record) of
                false ->
                    case lib_login:create(Record) of
                        true ->
                            return_roles(State#state{account = Account, status = ?WAIT_STATUS});
                        undefined ->
                            {stop, normal, State}
                    end;
                true ->
                    return_roles(State#state{account = Account, status = ?WAIT_STATUS});
                undefined ->
                    {stop, normal, State}
            end;    
     	false ->
            {stop, normal, State}
    end;

handle(Record = #request_create{name = Name}, State = #state{socket = Socket}) ->
    case lib_name:check(#check_name{name = Name, sql = io_lib:format("select account_id from account where account = ~s",[util:to_binary(Name)]), args = [len, verifym, no_exist]}) of
        true -> 
            case lib_login:create(Record, State) of
                true ->
                    return_roles(State#state{status = ?WAIT_STATUS}); 
                false ->
                    {stop, create_role_fail, State}
            end;
        {false, ErrCode} ->
            Bin = pack:pack(pack, #return_tips{tips_code = ErrCode}),
            erlang:port_command(Socket, Bin, [force]),
            {noreply, State}
    end;

handle(#request_enter{role_id = RoleId}, State = #state{status = ?WAIT_STATUS, role_ids = RoleIds}) ->
    case lists:member(RoleId, RoleIds) of
        false ->
            {noreply, State};
        true ->
            case lib_login:enter(RoleId, State) of
                {ok, Pid} ->
                    {noreply, State#state{pid = Pid}};
                _E ->
                    ?ERROR("obj request enter error, ~w", [_E]),
                    {stop, request_enter_error, State}
            end
    end;

handle(_, State) ->
	{noreply, State}.

return_roles(State = #state{socket = Socket, account = Account}) ->
    case lib_login:roles(Account) of
        undefined ->
            {stop, normal, State};
        Rows ->
            RoleIds = [RoleId || #roles{role_id = RoleId} <- Rows],
            Bin = pack:pack(pack, #return_login{list = Rows}),
            erlang:port_command(Socket, Bin, [force]),
            {noreply, State#state{role_ids = RoleIds}}
    end.
