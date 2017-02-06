-ifndef(REQUEST_BUSY1_PB_H).
-define(REQUEST_BUSY1_PB_H, true).
-record(request_busy1, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_BUSY1_PB_H).
-define(RETURN_BUSY1_PB_H, true).
-record(return_busy1, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(REQUEST_PERSON_BUSY2_PB_H).
-define(REQUEST_PERSON_BUSY2_PB_H, true).
-record(request_person_busy2, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_PERSON_BUSY2_PB_H).
-define(RETURN_PERSON_BUSY2_PB_H, true).
-record(return_person_busy2, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(REQUEST_BUSY_JNL_PB_H).
-define(REQUEST_BUSY_JNL_PB_H, true).
-record(request_busy_jnl, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_BUSY_JNL_PB_H).
-define(RETURN_BUSY_JNL_PB_H, true).
-record(return_busy_jnl, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

