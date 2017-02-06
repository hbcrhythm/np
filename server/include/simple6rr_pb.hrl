-ifndef(PERSON_PB_H).
-define(PERSON_PB_H, true).
-record(person, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(PE12312RSON1_PB_H).
-define(PE12312RSON1_PB_H, true).
-record(pe12312rson1, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

-ifndef(PE123123RSON_PB_H).
-define(PE123123RSON_PB_H, true).
-record(pe123123rson, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

