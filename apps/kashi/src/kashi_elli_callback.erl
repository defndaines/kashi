-module(kashi_elli_callback).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-behavior(elli_handler).

handle(Req, Args) ->
	%% Delegate to three-arg handler function.
	handle(Req#req.method, elli_request:path(Req), Req, Args).

%% Calls returning content should return HTTP code 200.
%% Calls returning no content in response to valid requests (e.g., an empty bid response which is one option for indicating no-bid, a win notice that does not return markup) should return HTTP 204.
%% Invalid calls (e.g., a bid request containing a malformed or corrupt payload) should return HTTP 400 with no content.
handle('POST', [<<"bid">>], Req, _Args) ->
  case elli_request:get_header(<<"Content-Type">>, Req, <<"application/json">>) of
    <<"application/json">> ->
      try jsx:decode(Req#req.body, [return_maps]) of
        JSON ->
          {ok, [{<<"Content-Type">>, <<"application/json">>}], jsx:encode(JSON)}
      catch
        error:badarg -> {400, [], <<"">>}
      end;
    _ ->
      {400, [], <<"">>}
  end;

handle(_, _, _Req, _Args) ->
	{400, [], <<"">>}.

%% @doc: Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return 'ok'.
handle_event(_Event, _Data, _Args) ->
	ok.
