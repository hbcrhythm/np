#!/usr/bin/env bash

## @author hbc 670762853@qq.com
## @doc    shell 环境下的编译操作

cd $(dirname $BASH_SOURCE)
: > make_proto
echo -e ".PHONY: cfg proto parse\n\n" > "Makefile"

## @doc 生成相应的配置文件
##	    macro_file 为生成的宏文件名字符串,每个字符串已逗号隔开
##	    ouput      为生成的配置文件的目录
##		inc        为生成的include文件的目录
## @end
make_cfg(){
	input="../../cfg/"
	output="../cfg/"
	inc="../include/"
	macro_files="cfg_err_code,"
	files=`ls ${input}`
	files=`echo $files | sed s/.iex//g`
	echo $files | awk -F "\t" -v inc=$inc -v input=$input -v output=$output -v macro_files=$macro_files '
	BEGIN { string="cfg:" }{
		split($1, arr, " ")
		for(i in arr){
			if(match(macro_files, arr[i])){
				string = string " " output arr[i] ".erl " inc arr[i] ".hrl"
			}else{
				string = string " " output arr[i] ".erl"
			}
		}
		string = string "\n\n"
		for(i in arr){
			marco = ""
			if(match(macro_files, arr[i])){
				string = string output arr[i] ".erl " inc arr[i] ".hrl: " input arr[i] ".iex\n"
				marco = "marco" 
			}else{
				string = string output arr[i] ".erl:" input arr[i] ".iex\n"
			}
			string = string"\t@(php ../php/parse_cfg.php " arr[i] " " output arr[i] ".erl " input arr[i]".iex " marco " )\n\n"
		}
	}END { print string >> "Makefile" }'
}

## @doc 生成相应的协议文件 ph模块和lib模块
## 		ph模块和lib模块只会生成一次(除非删除才会重新生成),如果要重新生成相应的协议文件,可以删除proto目录下的对应的.bak文件就可以
## @end
make_proto(){
	if [[ ! -f "../include/cfg_hrl.hrl" ]]; then
		: > "../include/cfg_hrl.hrl"
	fi
	if [[ ! -f "../src/parse.erl" ]]; then
		parse="-module(parse).\n-export([parse/1]).\n"
		echo -e ${parse} > "../src/parse.erl"
	fi
	if [[ ! -f "../src/unparse.erl" ]]; then
		unparse="-module(unparse).\n-export([unparse/2]).\n"
		echo -e ${unparse} > "../src/unparse.erl"
	fi
	if [[ ! -d "../proto" ]]; then
		mkdir "../proto"
	fi
	protofiles=`ls ../../proto`
	protofiles=`echo $protofiles | sed s/.proto//g`
	echo ${protofiles} | awk -F "\t" '
	BEGIN{
		string="proto:"
		parse="parse:"
	}{
		split($0, arr, " ")
		for(i in arr){
			string = string " ../include/"arr[i]"_pb.hrl ../ebin/"arr[i]"_pb.beam"
			parse = parse " ../proto/" arr[i] ".bak " "../src/lib_" arr[i] ".erl " "../src/ph_" arr[i] ".erl "
		}
		string = string "\n\n"
		parse = parse " ../proto/undefined.bak\n\n"
		for(i in arr){
			string = string "../include/"arr[i]"_pb.hrl ../ebin/"arr[i]"_pb.beam : ../../proto/"arr[i]".proto\n"
			parse = parse "../src/lib_" arr[i] ".erl " "../src/ph_" arr[i] ".erl " "../proto/" arr[i] ".bak : ../../proto/" arr[i] ".proto\n"
			parse = parse "\t@$(shell touch ../proto/" arr[i] ".bak)\n"
			parse = parse "\t@(php ../php/parse_pt.php "arr[i]")\n"
			echo "erl -noshell -pa ../deps/protobuffs/ebin -eval \" protobuffs_compile:scan_file(\\\"../../proto/\\\" ++ \\\""arr[i]".proto\\\", [{output_include_dir, \\\"../include\\\"}, {output_ebin_dir,\\\"../ebin\\\"}]). \" -s erlang halt)" 
			string = string "\t@(erl -noshell -pa ../deps/protobuffs/ebin -eval \" protobuffs_compile:scan_file(\\\"../../proto/\\\" ++ \\\""arr[i]".proto\\\", [{output_include_dir, \\\"../include\\\"}, {output_ebin_dir,\\\"../ebin\\\"}]). \" -s erlang halt) \n\n"
		}
		parse = parse "../proto/undefined.bak : \n"
		parse = parse "\t@(php ../php/parse_pt.php undefined undefined)" 

	}END{
		print string >> "Makefile"
		print parse  >> "Makefile"
	}'
}


make_cfg
make_proto

cpuWorks=`grep -c 'processor' /proc/cpuinfo`
make -j ${cpuWorks} cfg
make -j ${cpuWorks} proto
make -j ${cpuWorks} parse
