-module(kashi_elli_callback).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-behavior(elli_handler).

handle(Req, Args) ->
	%% Delegate to three-arg handler function.
	handle(Req#req.method, elli_request:path(Req), Req, Args).

handle('POST', [<<"bid">>], Req, _Args) ->
  JSON = jsx:decode(Req#req.body, [return_maps]),
  {ok, [{<<"Content-type">>, <<"application/json">>}], jsx:encode(JSON)};

handle(_, _, _Req, _Args) ->
	{404, [], <<"Not Found">>}.

%% @doc: Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return 'ok'.
handle_event(_Event, _Data, _Args) ->
	ok.
