-module(de2Binary).  
-export([de2Binary/1]). 
 
tempData([0])-> [];  
tempData([Num]) ->
    Result = Num band 1,     
    integer_to_list(Result) ++ tempData([Num bsr 1]).  
 
de2Binary(Num)->  
    BinaryList = lists:reverse(tempData([Num])),
    LoopTimes = length(BinaryList) rem 8,
    if LoopTimes > 0 -> addBlank(BinaryList,8 - LoopTimes);
       true -> BinaryList
    end.
 
addBlank(BinaryList,0) -> BinaryList;
addBlank(BinaryList,Times) ->
    addBlank("0" ++ BinaryList,Times-1).