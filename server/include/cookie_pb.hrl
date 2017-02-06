-ifndef(COOKIE_PB_H).
-define(COOKIE_PB_H, true).
-record(cookie, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(COOKIE1_PB_H).
-define(COOKIE1_PB_H, true).
-record(cookie1, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

-ifndef(COOKIE2_PB_H).
-define(COOKIE2_PB_H, true).
-record(cookie2, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(COOKIE3_PB_H).
-define(COOKIE3_PB_H, true).
-record(cookie3, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

