%% @doc 角色数据处理模块,用于处理角色内存数据和数据库数据之间的变换
%% @end
-module(lib_role_data).
-author('hbc 670762853@qq.com').
-include("common.hrl").

-export([fetch/1]).

%% @spec fetch(RoleId) -> Obj
%% @type Obj :: #obj{}
%% @doc 获取角色全部数据
%% @end
fetch(RoleId) ->
    F = fun 
        Fetch(base, Obj = #obj{id = Id}) ->
            Sql = io_lib:format("select ~s from role where id = ~w", [?ROLE_FIELDS, Id]),
            case db:execute(#sql_packet{sql = Sql, as_record = #as_record{name = base, list = record_info(fields, base)}}) of
                #sql_packet{result_rows = [Base], code = undefined} ->
                    Obj#obj{base = Base};
                #sql_packet{code = _Code, msg = _Msg} ->
                    ?ERROR("fetch error, code: ~w, msg: ~w",[_Code, _Msg]),
                    exit(self(), _Msg)
            end;
        Fetch(assets, Obj = #obj{id = Id}) ->
            Sql = io_lib:format("select ~s from role where id = ~w",[?ROLE_ASSETS, Id]),
            case db:execute(#sql_packet{sql = Sql, as_record = #as_record{name = assets, list = record_info(fields, assets)}}) of
                #sql_packet{result_rows = Assets, code = undefined} ->
                    Obj#obj{assets = Assets};
                #sql_packet{code = _Code, msg = _Msg} ->
                    ?ERROR("fetch error, code: ~w, msg: ~w",[_Code, _Msg]),
                    exit(self(), _Msg)
            end;
        Fetch(mods, Obj = #obj{id = Id}) ->
            Sql = io_lib:format("select ~s from role_mods where id = ~w",[?ROLE_MODS, Id]),
            case db:execute(#sql_packet{sql = Sql, as_record = #as_record{name = mods, list = record_info(fields, mods)}}) of
                #sql_packet{result_rows = Mods, code = undefined} ->
                    Obj#obj{mods = Mods};
                #sql_packet{code = _Code, msg = _Msg} ->
                    ?ERROR("fetch error, code: ~w, msg: ~w",[_Code, _Msg]),
                    exit(self(), _Msg)
            end;
        Fetch([H| T], Obj) ->
            NewObj = Fetch(H, Obj),
            Fetch(T, NewObj);
        Fetch([], Obj) -> Obj
    end,
    F([base, assets, mods], #obj{id = RoleId}).
    
