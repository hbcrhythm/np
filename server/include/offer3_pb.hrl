-ifndef(PERSON_PB_H).
-define(PERSON_PB_H, true).
-record(person, {
    name1 = erlang:error({required, name1}),
    address1 = erlang:error({required, address1}),
    phone_number1 = erlang:error({required, phone_number1}),
    age1 = []
}).
-endif.

