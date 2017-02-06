%%----------------------------------------------------
%% @doc 各种id获取模块 
%%      角色id, 行会id 需要保存到数据库, 
%%      怪物id, 宠物id 目前不保存
%% @end
%%----------------------------------------------------
-module(mod_id).
-author('hbc 670762853@qq.com').
-behaviour(gen_server).
-include("common.hrl").
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([fetch/1]).

-record(state, {ids = []}).


fetch(Type) ->
    gen_server:call(?MODULE, {fetch, Type}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true), 
    case loading() of
        undefined -> {stop, loading_sys_env_fail};
        Ids when is_list(Ids) ->
            State = #state{ids = Ids},
            {ok, State}
    end.

%% @doc 返回的state里面的type对应的id,是下一次可以直接使用的id
%% @end
handle_call({fetch, Type = ?ROLE_ID}, _From, State = #state{ids = Ids}) ->
    {Id, NewIds} = case lists:keyfind(Type, 1, Ids) of
        false -> {1, [{Type, 2} | Ids]};
        {Type, Value} -> {Value, lists:keyreplace(Type, 1, Ids, {Type, Value + 1})}
    end,
    ServerId = util:get_config(?APPLICATION, server_id, 1),
    <<ObjId:?ROLE_ID_LEN>> = <<ServerId:?PREFIX_ID, Id:?POSTFIX_ID>>,
    {reply, ObjId, State#state{ids = NewIds}};
    
handle_call({fetch, Type}, _From, State = #state{ids = Ids}) ->
    case lists:keyfind(Type, 1, Ids) of
        false ->
            {reply, 1, State#state{ids = [{Type, 2} | Ids]}};
        {Type, Id} ->
            NewIds = lists:keyreplace(Type, 1, Ids, {Type, Id + 1}),
            {reply, Id, State#state{ids = NewIds}}
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    save(State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

loading() ->
    Sql = "select ids from sys_env limit 1",
    case db:execute(#sql_packet{sql = Sql}) of
        #sql_packet{result_rows = [Ids], code = undefined} ->
            util:bitstring_to_term(Ids);
        #sql_packet{result_rows = []} ->
            [];
        #sql_packet{code = _Code, msg = _Msg} ->
            ?ERROR("select ids from sys_env error, code: ~w, msg: ~w",[_Code, _Msg]),
            undefined
    end.

save(#state{ids = Ids}) ->
    NewIds = [Term || Term = {Type, _} <- Ids, lists:member(Type, ?SAVE_ID_TYPE)],
    Sql = io_lib:format("insert into sys_env(ids) values(~s)", [util:term_to_bitstring(NewIds)]),
    case db:execute(#sql_packet{sql = Sql}) of
        #sql_packet{affected_rows = 1} ->
            ignore;
        #sql_packet{code = _Code, msg = _Msg} ->
            ?ERROR("save mod id error: code:~w, msg: ~w",[_Code, _Msg]),
            ignore
    end.
