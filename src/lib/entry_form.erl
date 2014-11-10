-module(entry_form, [InitialData, Errors]).
-compile(export_all).

form_fields() ->
    [
     {title, [{type, char_field},
                 {label, "Title"},
                 {required, true},
                 {min_length, 5},
                 {max_length, 255},
                 {html_options, [{class, "form-control"},
                                {placeholder, "Title"},
                                {autofocus, autofocus},
                                {required, required}]}]},
     {content, [{type, char_field},
                {label, "Content"},
                {min_length, 5},
                {max_length, 25},
                {required, true},
                {html_options, [{class, "form-control"},
                                {placeholder, "Content"},
                                {required, required}]}]}
    ].



%% Proxies
data() ->
    InitialData.

errors() ->
    Errors.

fields() ->
    boss_form:fields(form_fields(), InitialData, Errors).

as_table() ->
    boss_form:as_table(form_fields(), InitialData, Errors).

