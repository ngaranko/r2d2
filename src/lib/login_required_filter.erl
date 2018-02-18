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
            case user_in_session(RequestContext) of
                false ->
                    {redirect_to_login(Config), RequestContext};
                true ->
                    {ok, RequestContext}
            end
    end.

user_in_session(RequestContext) ->
    %% Check if user in session
    case boss_session:get_session_data(filter_get_session_id(RequestContext), user_id) of
        undefined ->
            false;
        {error, _} ->
            false;
        _ ->
            true
    end.

filter_get_session_id(RequestContext) ->
    %% Get session_id from requestContext or Cookies
    case proplists:get_value(session_id, RequestContext) of
        undefined ->
            %% Try loading session_id from request, using boss_web_controller
            boss_web_controller:generate_session_id(proplists:get_value(request, RequestContext));
        SessionID ->
            SessionID
    end.

redirect_to_login(Config) ->
    {redirect, proplists:get_value(login_uri, Config, "/login")}.
