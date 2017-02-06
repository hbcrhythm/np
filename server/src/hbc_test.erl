-module(hbc_test).

-include("common.hrl").

-export([hello/0, hello1/0]).

hello() ->
	application:start(compiler),
	application:start(syntax_tools),
	application:start(goldrush),
	application:start(lager),
	io:format("hhh~w",[hbc]),
	application:start(emysql),
	application:start(protobuffs),
	application:start(np),
	protobuffs_compile:scan_file("simple.proto"),
	lager:info("hbc say , hello world"),
	lager:error("hbchbc ~w",[#obj{}]).

hello1() ->
	?INFO("hbc say world",[]),
	?ERROR("hbc say world ",[]),
	?WARNING("hbc say world ",[]).
