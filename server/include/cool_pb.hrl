-ifndef(COOL_PB_H).
-define(COOL_PB_H, true).
-record(cool, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(COOL2_PB_H).
-define(COOL2_PB_H, true).
-record(cool2, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

-ifndef(COOL3_PB_H).
-define(COOL3_PB_H, true).
-record(cool3, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(COOL4_PB_H).
-define(COOL4_PB_H, true).
-record(cool4, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

