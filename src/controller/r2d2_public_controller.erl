-module(r2d2_public_controller, [Req, SessionID]).
-compile(export_all).


index('GET', [], Context) ->
    {ok, Context};
index('POST', [], Context) ->
    {ok, Context}.

login('GET', [], Context) ->
    case proplists:get_value(username, boss_session:get_session_data(SessionID)) of
        undefined ->
            Form = boss_form:new(login_form, []),
            {ok, [{form, Form} | Context]};
        Username ->
            {redirect, "/panel"}
    end;

login('POST', [], Context) ->
    Form = boss_form:new(login_form, []),
    case boss_form:validate(Form, Req:post_params()) of
        {ok, CleanedData} ->
            boss_session:set_session_data(SessionID, username, proplists:get_value(username, CleanedData)),
            {redirect, "/panel"};
        {error, FormWithErrors} ->
            {ok, [{form, FormWithErrors} | Context]}
    end.