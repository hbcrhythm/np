.PHONY: cfg proto parse


cfg: ../cfg/cfg_err_code.erl ../include/cfg_err_code.hrl ../cfg/cfg_missio11.erl ../cfg/cfg_missio12.erl

../cfg/cfg_err_code.erl ../include/cfg_err_code.hrl: ../../cfg/cfg_err_code.iex
	@(php ../php/parse_cfg.php cfg_err_code ../cfg/cfg_err_code.erl ../../cfg/cfg_err_code.iex marco )

../cfg/cfg_missio11.erl:../../cfg/cfg_missio11.iex
	@(php ../php/parse_cfg.php cfg_missio11 ../cfg/cfg_missio11.erl ../../cfg/cfg_missio11.iex  )

../cfg/cfg_missio12.erl:../../cfg/cfg_missio12.iex
	@(php ../php/parse_cfg.php cfg_missio12 ../cfg/cfg_missio12.erl ../../cfg/cfg_missio12.iex  )


proto: ../include/busy_pb.hrl ../ebin/busy_pb.beam ../include/common_pb.hrl ../ebin/common_pb.beam ../include/cooke_pb.hrl ../ebin/cooke_pb.beam ../include/login_pb.hrl ../ebin/login_pb.beam ../include/master_pb.hrl ../ebin/master_pb.beam

../include/busy_pb.hrl ../ebin/busy_pb.beam : ../../proto/busy.proto
	@(erl -noshell -pa ../deps/protobuffs/ebin -eval " protobuffs_compile:scan_file(\"../../proto/\" ++ \"busy.proto\", [{output_include_dir, \"../include\"}, {output_ebin_dir,\"../ebin\"}]). " -s erlang halt) 

../include/common_pb.hrl ../ebin/common_pb.beam : ../../proto/common.proto
	@(erl -noshell -pa ../deps/protobuffs/ebin -eval " protobuffs_compile:scan_file(\"../../proto/\" ++ \"common.proto\", [{output_include_dir, \"../include\"}, {output_ebin_dir,\"../ebin\"}]). " -s erlang halt) 

../include/cooke_pb.hrl ../ebin/cooke_pb.beam : ../../proto/cooke.proto
	@(erl -noshell -pa ../deps/protobuffs/ebin -eval " protobuffs_compile:scan_file(\"../../proto/\" ++ \"cooke.proto\", [{output_include_dir, \"../include\"}, {output_ebin_dir,\"../ebin\"}]). " -s erlang halt) 

../include/login_pb.hrl ../ebin/login_pb.beam : ../../proto/login.proto
	@(erl -noshell -pa ../deps/protobuffs/ebin -eval " protobuffs_compile:scan_file(\"../../proto/\" ++ \"login.proto\", [{output_include_dir, \"../include\"}, {output_ebin_dir,\"../ebin\"}]). " -s erlang halt) 

../include/master_pb.hrl ../ebin/master_pb.beam : ../../proto/master.proto
	@(erl -noshell -pa ../deps/protobuffs/ebin -eval " protobuffs_compile:scan_file(\"../../proto/\" ++ \"master.proto\", [{output_include_dir, \"../include\"}, {output_ebin_dir,\"../ebin\"}]). " -s erlang halt) 


parse: ../proto/busy.bak ../src/lib_busy.erl ../src/ph_busy.erl  ../proto/common.bak ../src/lib_common.erl ../src/ph_common.erl  ../proto/cooke.bak ../src/lib_cooke.erl ../src/ph_cooke.erl  ../proto/login.bak ../src/lib_login.erl ../src/ph_login.erl  ../proto/master.bak ../src/lib_master.erl ../src/ph_master.erl  ../proto/undefined.bak

../src/lib_busy.erl ../src/ph_busy.erl ../proto/busy.bak : ../../proto/busy.proto
	@$(shell touch ../proto/busy.bak)
	@(php ../php/parse_pt.php busy)
../src/lib_common.erl ../src/ph_common.erl ../proto/common.bak : ../../proto/common.proto
	@$(shell touch ../proto/common.bak)
	@(php ../php/parse_pt.php common)
../src/lib_cooke.erl ../src/ph_cooke.erl ../proto/cooke.bak : ../../proto/cooke.proto
	@$(shell touch ../proto/cooke.bak)
	@(php ../php/parse_pt.php cooke)
../src/lib_login.erl ../src/ph_login.erl ../proto/login.bak : ../../proto/login.proto
	@$(shell touch ../proto/login.bak)
	@(php ../php/parse_pt.php login)
../src/lib_master.erl ../src/ph_master.erl ../proto/master.bak : ../../proto/master.proto
	@$(shell touch ../proto/master.bak)
	@(php ../php/parse_pt.php master)
../proto/undefined.bak : 
	@(php ../php/parse_pt.php undefined undefined)
