-ifndef(REQUEST_MASTER_PB_H).
-define(REQUEST_MASTER_PB_H, true).
-record(request_master, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_MASTER_PB_H).
-define(RETURN_MASTER_PB_H, true).
-record(return_master, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(REQUEST_MASTER_ONE_PB_H).
-define(REQUEST_MASTER_ONE_PB_H, true).
-record(request_master_one, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_MASTER_ONE_PB_H).
-define(RETURN_MASTER_ONE_PB_H, true).
-record(return_master_one, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(REQUEST_MASTER_TWO_PB_H).
-define(REQUEST_MASTER_TWO_PB_H, true).
-record(request_master_two, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_MASTER_TWO_PB_H).
-define(RETURN_MASTER_TWO_PB_H, true).
-record(return_master_two, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

