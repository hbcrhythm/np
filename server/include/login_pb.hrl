-ifndef(REQUEST_LOGIN_PB_H).
-define(REQUEST_LOGIN_PB_H, true).
-record(request_login, {
    account = erlang:error({required, account}),
    timestamp = erlang:error({required, timestamp}),
    sign = erlang:error({required, sign}),
    platform_id = erlang:error({required, platform_id}),
    device_no = erlang:error({required, device_no}),
    channel_id = erlang:error({required, channel_id}),
    version = erlang:error({required, version}),
    ext = erlang:error({required, ext})
}).
-endif.

-ifndef(RETURN_LOGIN_PB_H).
-define(RETURN_LOGIN_PB_H, true).
-record(return_login, {
    list = []
}).
-endif.

-ifndef(REQUEST_CREATE_PB_H).
-define(REQUEST_CREATE_PB_H, true).
-record(request_create, {
    name = erlang:error({required, name}),
    career = erlang:error({required, career}),
    sex = erlang:error({required, sex})
}).
-endif.

-ifndef(REQUEST_ENTER_PB_H).
-define(REQUEST_ENTER_PB_H, true).
-record(request_enter, {
    role_id = erlang:error({required, role_id})
}).
-endif.

-ifndef(ROLES_PB_H).
-define(ROLES_PB_H, true).
-record(roles, {
    role_id = erlang:error({required, role_id}),
    role_name = erlang:error({required, role_name}),
    career = erlang:error({required, career}),
    sex = erlang:error({required, sex}),
    level = erlang:error({required, level})
}).
-endif.

