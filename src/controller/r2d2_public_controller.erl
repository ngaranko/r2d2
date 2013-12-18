-module(r2d2_public_controller, [Req]).
-compile(export_all).


index('GET', [], Context) ->
    {ok, Context};
index('POST', [], Context) ->
    {ok, Context}.

login('GET', [], Context) ->
    Form = boss_form:new(login_form, []),
    {ok, [{form, Form} | Context]};
login('POST', [], Context) ->
    Form = boss_form:new(login_form, []),
    case boss_form:validate(Form, Req:post_params()) of
        {ok, CleanedData} ->
            {output, "HAHA"};
        {error, FormWithErrors} ->
            {ok, [{form, FormWithErrors} | Context]}
    end.