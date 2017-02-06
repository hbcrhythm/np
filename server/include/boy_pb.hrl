-ifndef(BOY_PB_H).
-define(BOY_PB_H, true).
-record(boy, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(BOY1_PB_H).
-define(BOY1_PB_H, true).
-record(boy1, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

-ifndef(BOY3_PB_H).
-define(BOY3_PB_H, true).
-record(boy3, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(BOY4_PB_H).
-define(BOY4_PB_H, true).
-record(boy4, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

