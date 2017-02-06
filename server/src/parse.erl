-module(parse).
-export([parse/1]).

%%start busy
parse(request_busy1) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {pt_no, 30001}];
parse(return_busy1) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {pt_no, 30001}];
parse(request_person_busy2) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {pt_no, 30002}];
parse(return_person_busy2) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {pt_no, 30002}];
parse(request_busy_jnl) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {pt_no, 30003}];
parse(return_busy_jnl) -> [{module_pb, busy_pb}, {module_logic, ph_busy}, {pt_no, 30003}];
%%end busy
%%start common
parse(return_tips) -> [{module_pb, common_pb}, {module_logic, ph_common}, {pt_no, 10101}];
%%end common
%%start cooke
parse(request_hehe) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {pt_no, 20001}];
parse(return_hehe) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {pt_no, 20001}];
parse(request_ioio) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {pt_no, 20002}];
parse(return_ioio) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {pt_no, 20002}];
parse(request_jujuij) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {pt_no, 20003}];
parse(return_jujuij) -> [{module_pb, cooke_pb}, {module_logic, ph_cooke}, {pt_no, 20003}];
%%end cooke
%%start login
parse(request_login) -> [{module_pb, login_pb}, {module_logic, ph_login}, {pt_no, 10001}];
parse(return_login) -> [{module_pb, login_pb}, {module_logic, ph_login}, {pt_no, 10001}];
parse(request_create) -> [{module_pb, login_pb}, {module_logic, ph_login}, {pt_no, 10002}];
parse(request_enter) -> [{module_pb, login_pb}, {module_logic, ph_login}, {pt_no, 10003}];
%%end login
%%start master
parse(request_master) -> [{module_pb, master_pb}, {module_logic, ph_master}, {pt_no, 50001}];
parse(return_master) -> [{module_pb, master_pb}, {module_logic, ph_master}, {pt_no, 50001}];
parse(request_master_one) -> [{module_pb, master_pb}, {module_logic, ph_master}, {pt_no, 50002}];
parse(return_master_one) -> [{module_pb, master_pb}, {module_logic, ph_master}, {pt_no, 50002}];
parse(request_master_two) -> [{module_pb, master_pb}, {module_logic, ph_master}, {pt_no, 50003}];
parse(return_master_two) -> [{module_pb, master_pb}, {module_logic, ph_master}, {pt_no, 50003}];
%%end master
parse(_) -> undefined.
