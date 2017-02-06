@echo off
erl -name np@127.0.0.1 -setcookie np  -eval "case mmake:all(10, [{d, debug}]) of up_to_date -> halt(); error -> halt(1)  end."
pause
echo "compile success!"