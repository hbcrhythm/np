@echo off
rem 注意 这里后面的表达式不能使用''  要使用""括起来 否则会导致解析出来的数据有异常

erl -pa ../deps/protobuffs/ebin -eval "{ok, Files} = file:list_dir(\"../proto\"),[protobuffs_compile:scan_file(\"../proto/\" ++ File, [{output_include_dir, \"../include\"}, {output_ebin_dir, \"../ebin\"}]) || File <- Files]."