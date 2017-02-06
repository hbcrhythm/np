@echo off

rem @doc windows版本,只提供生成配置文件,并且每次都是全部配置重新生成一遍

start for /r %%i in (..\..\cfg\cfg*) do php -f ../php/parse_cfg.php %%~ni ../cfg/%%~ni.erl %%i
pause