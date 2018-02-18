-module(r2d2_public_controller, [Req, SessionID]).
-compile(export_all).


index('GET', [], Context) ->
    {ok, Context};
index('POST', [], Context) ->
    {ok, Context}.


login('GET', [], Context) ->
    case proplists:get_value(user_id, boss_session:get_session_data(SessionID)) of
        undefined ->
            Form = boss_form:new(login_form, []),
            {{ok, [{form, Form}]}, Context};
        _ ->
            {{redirect, "/panel"}, Context}
    end;

login('POST', [], Context) ->
    Form = boss_form:new(login_form, []),
    case boss_form:validate(Form, Req:post_params()) of
        {ok, CleanedData} ->
            Username = binary_to_list(proplists:get_value(username, CleanedData)),
            Password = binary_to_list(proplists:get_value(password, CleanedData)),
            case user_lib:check_credentials(Username, Password) of
                false ->
                    {{ok, [{form, Form}, {login_error, 1} | Context]}, Context};
                Account ->
                    boss_session:set_session_data(SessionID, user_id, Account:id()),
                    {{redirect, "/panel"}, Context}
            end;
        {error, FormWithErrors} ->
            {{ok, [{form, FormWithErrors} | Context]}, Context}
    end.
