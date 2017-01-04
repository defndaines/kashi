%%%-------------------------------------------------------------------
%% @doc kashi top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(kashi_sup).

-behavior(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id, StartFunc, Restart, Shutdown, Type, Modules}
init([]) ->
  ElliOpts = [{callback, kashi_elli_callback}, {port, 3000}],
  ElliSpec = { kashi_http
             , {elli, start_link, [ElliOpts]}
             , permanent
             , 5000
             , worker
             , [elli]},
  {ok, { {one_for_all, 5, 10}, [ElliSpec]} }.

%%====================================================================
%% Internal functions
%%====================================================================
