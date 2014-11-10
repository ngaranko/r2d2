-module(r2d2_panel_controller, [Req, SessionID]).
-compile(export_all).


index('GET', [], Context) ->
    Entries = boss_db:find(entry, []),
    {ok, [{entries, Entries} | Context]};
index('POST', [], Context) ->
    {ok, Context}.

add('GET', [], Context) ->
    Form = boss_form:new(entry_form, []),
    {ok, [{form, Form} | Context]};
add('POST', [], Context) ->
    {ok, Context}.
