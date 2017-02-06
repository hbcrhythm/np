@echo off

rem @author hbc 670762853@qq.com
rem @doc windows版本,生成配置文件

set "curdir=%~dp0"
set "curdir=%curdir:\=/%"
set "curdir=%curdir::=%"
set var="cd /cygdrive/%curdir%; sh gen_config.sh;"
bash --login -i -c %var%
