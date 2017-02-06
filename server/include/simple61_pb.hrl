-ifndef(SIMPLE_PB_H).
-define(SIMPLE_PB_H, true).
-record(simple, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(SIMPLE2_PB_H).
-define(SIMPLE2_PB_H, true).
-record(simple2, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

-ifndef(SIMPLE3_PB_H).
-define(SIMPLE3_PB_H, true).
-record(simple3, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(SIMPLE4_PB_H).
-define(SIMPLE4_PB_H, true).
-record(simple4, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

