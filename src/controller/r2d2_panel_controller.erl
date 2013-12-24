-module(r2d2_panel_controller, [Req, SessionID]).
-compile(export_all).


index('GET', [], Context) ->
    {ok, Context};
index('POST', [], Context) ->
    {ok, Context}.
