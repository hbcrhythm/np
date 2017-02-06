@echo off

rem ----------------------------------------------
rem np启动(windows版本)
rem @author hbc 670762853@qq.com
rem @doc 注意，启动完的时候记得返回script目录，不然下次启动会报错，因为目录不对
rem ----------------------------------------------

title "np control"
set ERL=werl
set COOKIE=np
set NODE_NAME=np@localhost
set SMP=auto
set ERL_PROCESSES=102400
set ERL_PORT_MIN=40001
set ERL_PORT_MAX=40100
set NODE_NAME=NP_HHZ_1@127.0.0.1
set ROBOT_NODE_NAME=ROBOT_NP_HHZ_1@127.0.0.1

set inp=%1
if "%inp%" == "" goto fun_wait_input
goto fun_run

:where_to_go
	if [%1]==[] goto fun_wait_input
	goto end

:fun_wait_input
	set inp=
	echo.
	echo =======================================
	echo "make: make server"
	echo "start: start server"
	echo "gem_cfg: gennerate server config"
	echo "kill: kill server"
	echo "all: clean、make、start"
	echo "robot: start robot"
	echo.
	echo ---------------------------------------
	set /p inp=please input command:
	echo ---------------------------------------

:fun_run
	if [%inp%]==[make]  goto fun_make
	if [%inp%]==[start] goto fun_start
	if [%inp%]==[gen_cfg] goto fun_gen_cfg
	if [%inp%]==[kill]  goto fun_kill
	if [%inp%]==[all]	goto fun_all
	if [%inp%]==[robot] goto fun_robot
	goto where_to_go


:fun_make
	erl -eval "case mmake:all(10, [{d, debug}]) of up_to_date -> halt(); error -> halt(1)  end."
	goto where_to_go

:fun_start
	cd ..\
	werl -hidden -name %NODE_NAME% -setcookie %COOKIE% -boot start_sasl -pa ebin  deps/ranch/ebin deps/goldrush/ebin deps/lager/ebin deps/meck/ebin deps/protobuffs/ebin deps/emysql/ebin deps/jsx/ebin deps/cowlib/ebin deps/cowboy/ebin -s np start
	cd script
	rem start.bat 
	goto where_to_go

:fun_gen_cfg
	start for /r %%i in (..\..\cfg\*) do php -f ../php/parse_cfg.php %%~ni ../cfg/%%~ni.erl %%i
	goto where_to_go

:fun_kill
	taskkill /F /IM werl.exe
	goto where_to_go

:fun_all
	cd ..\ebin
	del *.beam
	echo ??àíerlang±àò????tíê3é
	cd ..\script
	erl -eval  "case mmake:all(10, [{d, debug}]) of up_to_date -> halt(); error -> halt(1)  end."
	rem taskkill /F /IM werl.exe
	werl -hidden -name np@localhost -setcookie np -pa ../ebin -s hbc_test hello
	goto where_to_go

:fun_robot
	cd ..\ebin
	werl -hidden -name %ROBOT_NODE_NAME% -setcookie %COOKIE% -boot start_sasl -pa ebin deps/goldrush/ebin deps/lager/ebin deps/meck/ebin deps/protobuffs/ebin deps/emysql/ebin -s np start
	cd script
	goto where_to_go

:end
