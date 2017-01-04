-module(kashi_elli_callback).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-behavior(elli_handler).

handle(Req, _Args) ->
	%% Delegate to three-arg handler function.
	handle(Req#req.method, elli_request:path(Req), Req).

handle('POST', [<<"bid">>], _Req) ->
  %% JSON = elli_request:post_arg(<<"bid">>, Req, <<"undefined">>),
	{ok, [], <<"Thank you for your request!">>};

handle(_, _, _Req) ->
	{404, [], <<"Not Found">>}.

%% @doc: Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return 'ok'.
handle_event(_Event, _Data, _Args) ->
	ok.
