-module(unparse).
-export([unparse/2]).

%%start login
unparse(server, 10001) -> [{module_pb, login_pb}, {module_logic, ph_login}, {function, decode_request_login}];
unparse(client, 10001) -> [{module_pb, login_pb}, {module_logic, ph_login}, {function, decode_return_login}];
unparse(server, 10002) -> [{module_pb, login_pb}, {module_logic, ph_login}, {function, decode_request_create}];
unparse(server, 10003) -> [{module_pb, login_pb}, {module_logic, ph_login}, {function, decode_request_enter}];
%%end login
%%start busy
unparse(server, 30001) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {function, decode_request_busy1}];
unparse(client, 30001) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {function, decode_return_busy1}];
unparse(server, 30002) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {function, decode_request_person_busy2}];
unparse(client, 30002) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {function, decode_return_person_busy2}];
unparse(server, 30003) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {function, decode_request_busy_jnl}];
unparse(client, 30003) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {function, decode_return_busy_jnl}];
%%end busy
%%start common
unparse(client, 10101) -> [{module_pb, common_pb}, {module_logic, ph_common}, {function, decode_return_tips}];
%%end common
%%start cooke
unparse(server, 20001) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {function, decode_request_hehe}];
unparse(client, 20001) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {function, decode_return_hehe}];
unparse(server, 20002) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {function, decode_request_ioio}];
unparse(client, 20002) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {function, decode_return_ioio}];
unparse(server, 20003) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {function, decode_request_jujuij}];
unparse(client, 20003) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {function, decode_return_jujuij}];
%%end cooke
%%start master
unparse(server, 50001) -> [{module_pb, master_pb}, {module_logic, ph_master}, {function, decode_request_master}];
unparse(client, 50001) -> [{module_pb, master_pb}, {module_logic, ph_master}, {function, decode_return_master}];
unparse(server, 50002) -> [{module_pb, master_pb}, {module_logic, ph_master}, {function, decode_request_master_one}];
unparse(client, 50002) -> [{module_pb, master_pb}, {module_logic, ph_master}, {function, decode_return_master_one}];
unparse(server, 50003) -> [{module_pb, master_pb}, {module_logic, ph_master}, {function, decode_request_master_two}];
unparse(client, 50003) -> [{module_pb, master_pb}, {module_logic, ph_master}, {function, decode_return_master_two}];
%%end master
unparse(_, _) -> undefined.
