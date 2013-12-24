-module(login_required_filter).
-export([before_filter/2]).

before_filter(undefined, RequestContext) ->
    before_filter([], RequestContext);
before_filter(Config, RequestContext) ->
    LoginExcempt = case proplists:get_value(login_excempt, Config, undefined) of
        undefined ->
            [];
        ControllersList ->
            ControllersList
    end,

    case lists:member(proplists:get_value(controller_module, RequestContext, undefined), LoginExcempt) of
        true ->
            {ok, RequestContext};
        false ->
            case get_nested_value(RequestContext, [session_id, username]) of
                undefined ->
                    %%redirect_to_login(Config);
                    {ok, RequestContext};
                Username ->
                    {ok, RequestContext}
            end
    end.

get_nested_value(undefined, _) ->
    undefined;
get_nested_value(Data, []) ->
    Data;
get_nested_value(Data, [Key | Keys]) ->
    get_nested_value(proplists:get_value(Key, Data), Keys).

redirect_to_login(Config) ->
    {redirect, proplists:get_value(login_uri, Config, "/public/login")}.
