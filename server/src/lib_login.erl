-module(lib_login).
-author('hbc 670762853@qq.com').
%% @doc 登录逻辑处理
%% @end
-include("common.hrl").
-include("login_pb.hrl").
-include("login.hrl").

-export([verify/1, roles/1, create/1, create/2, exist/1, enter/2]).

verify(#request_login{account = Account, timestamp = TimeStamp, sign = Sign}) ->
   case util:get_config(?APPLICATION, auth, {false, false}) of
       {false, false} -> true;
       {true,  SignCode} ->
            Md5 = Account ++ TimeStamp ++ SignCode,
            util:md5(Md5) =:= Sign
    end.

exist(#request_login{account = Account}) ->
    Sql = io_lib:format("select account from account where account = ~s", [Account]),
    case db:execute(#sql_packet{sql = Sql}) of
        #sql_packet{result_rows = [], code = undefined} -> false;
        #sql_packet{code = undefined} -> true;
        #sql_packet{code = _Code, msg = _Msg} ->
            ?ERROR("exist account error, code: ~w, msg: ~s",[_Code, _Msg]),
            undefined
    end.


create(#request_login{platform_id = PlatformId, account = Account, device_no = DeviceNo, channel_id = ChannelId}) ->
    Sql = io_lib:format("insert into account values(~s, ~w, ~w, ~s, ~w)",[Account, util:unixtime(), PlatformId, DeviceNo, ChannelId]),
    case db:execute(#sql_packet{sql = Sql}) of
        #sql_packet{affected_rows = 1, code = undefined} ->
            true;
        #sql_packet{code = _Code, msg = _Msg} ->
            ?ERROR("create account error, code: ~w, msg: ~s",[_Code, _Msg]),
            undefined
    end.
    
create(Record = #request_create{}, State) ->
    #obj{base = Base} = generate_obj(Record, State),
    [_H | FieldsValue] = util:to_list(Base), 
    Sql = io_lib:format("insert into role(~s) values(~w)",[?ROLE_FIELDS, FieldsValue]),
    case db:execute(sql = Sql) of
        #sql_packet{affected_rows = 1, code = undefined} ->
            true;
        #sql_packet{code = _Code, msg = _Msg} ->
            ?ERROR("create role error, code: ~w, msg ~w",[_Code, _Msg]),
            false
    end.
    
generate_obj(#request_create{name = Name, sex = Sex, career = Career}, #state{account = Account}) ->
    Base = #base{account = Account, role_name = Name, sex = Sex, level = 1, career = Career, create_time = util:unixtime()},
    Temp = #temp{tcp_pid = self()}, 
    #obj{id = mod_id:fetch(?ROLE_ID), type = ?OBJ_TYPE, base = Base, temp = Temp}.

roles(Account) ->
    case db:execute(#sql_packet{sql = io_lib:format("select id, name, career, sex, level from role where account = ~w",[Account]), as_record = #as_record{name = role, list = record_info(fields, roles)}}) of
       #sql_packet{result_rows = Rows, code = undefined} ->
           Rows;
       #sql_packet{code = _Code, msg = _Msg} ->
           ?ERROR("get roles error, code: ~w, msg :~s",[_Code, _Msg]),
           undefined
    end.

enter(RoleId, #state{socket = Socket, account = Account}) ->
    mod_role:start([RoleId, Account, Socket, self()]).


