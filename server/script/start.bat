@echo off
	cd ..\ 
	werl -hidden -name np@127.0.0.1 -setcookie np6 -boot start_sasl -pa ebin deps/goldrush/ebin deps/lager/ebin deps/meck/ebin deps/protobuffs/ebin deps/emysql/ebin -s np start	