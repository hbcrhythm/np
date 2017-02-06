-module(pack).
-author('hbc 670762853@qq.com').
-include("define.hrl").
-export([pack/2]).


%% @spec pack(Type, Value) -> undefined | term()
%% @type Type  :: atom
%% @type Value :: record() | binary() 
%% @doc 协议包处理, unpack2是解析服务端过来的协议包
%% @end

pack(pack, Record) when is_tuple(Record) ->
	RecordName = erlang:element(Record),
	case parse:parse(RecordName) of
		undefined ->
			undefined;
		TermList ->
			Module = proplists:get_value(module_pb, TermList),
 			PtNo   = proplists:get_value(pt_no, TermList),
 			<<PtNo:?PtNoLen,(erlang:iolist_to_binary(erlang:apply(Module, encode, [Record])))/binary>>
 	end;
pack(pack, _Info) ->
	undefined;

pack(unpack, Bin) ->
	pack(unpack, server, Bin);
pack(unpack2, Bin) ->
	pack(unpack, client, Bin).

pack(unpack, Type, <<PtNo:?PtNoLen, Content/binary>>) ->
	pack(PtNo, Type, Content);

pack(unpack, _Type, _Info) ->
	undefined;

pack(PtNo, Type, BinaryContent) when is_integer(PtNo) ->
	case unparse:unparse(Type, PtNo) of
		undefined ->
			undefined;
		TermList ->
			ModulePb    = proplists:get_value(module_pb, TermList),
			Func        = proplists:get_value(function, TermList),
            ModuleLogic = proplists:get_value(module_logic, TermList), 
            {ModuleLogic, erlang:apply(ModulePb, Func, [BinaryContent])}
	end;

pack(_PtNo, _Type, _BinaryContent) ->
	undefined.	
