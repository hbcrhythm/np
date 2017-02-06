-ifndef(PERSON_PB_H).
-define(PERSON_PB_H, true).
-record(person, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(PERSON1231_PB_H).
-define(PERSON1231_PB_H, true).
-record(person1231, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

-ifndef(PERS12312ON_PB_H).
-define(PERS12312ON_PB_H, true).
-record(pers12312on, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(PERS12312ON1_PB_H).
-define(PERS12312ON1_PB_H, true).
-record(pers12312on1, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

-ifndef(PERS12312ON2_PB_H).
-define(PERS12312ON2_PB_H, true).
-record(pers12312on2, {
    name = erlang:error({required, name}),
    address = erlang:error({required, address}),
    phone_number = erlang:error({required, phone_number}),
    age = []
}).
-endif.

-ifndef(PERS123123ON3_PB_H).
-define(PERS123123ON3_PB_H, true).
-record(pers123123on3, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

