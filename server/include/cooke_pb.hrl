-ifndef(REQUEST_HEHE_PB_H).
-define(REQUEST_HEHE_PB_H, true).
-record(request_hehe, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_HEHE_PB_H).
-define(RETURN_HEHE_PB_H, true).
-record(return_hehe, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(REQUEST_IOIO_PB_H).
-define(REQUEST_IOIO_PB_H, true).
-record(request_ioio, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_IOIO_PB_H).
-define(RETURN_IOIO_PB_H, true).
-record(return_ioio, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(REQUEST_JUJUIJ_PB_H).
-define(REQUEST_JUJUIJ_PB_H, true).
-record(request_jujuij, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(RETURN_JUJUIJ_PB_H).
-define(RETURN_JUJUIJ_PB_H, true).
-record(return_jujuij, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

