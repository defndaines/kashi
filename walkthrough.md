# Getting Started with Elli

Keeping track of the steps used to create a small web service using
[elli](https://github.com/knutin/elli).

## Create the Project

Create a new project. In this case, I've decided to call it “kashi”.

    $ rebar3 new release kashi

Note that this, be default, will add your e-mail address into the `LICENSE`
file.

Now, initialize the project with `git` (if you didn't create a repository, already).

    $ cd kashi
    $ git init .
    $ git add .
    $ git commit -m "Initializes kashi project"

## Add elli Dependency

Edit `rebar.config` to add the dependency.
```
{deps, [
  {elli, "", {git, "git://github.com/knutin/elli.git", {tag, "v1.0.5"}}}
]}.
```

And add the application to the ".app.src" configuration,
`apps/kashi/src/kashi.app.src`:
```
  {applications,
    [ kernel
    , stdlib
    , elli
    ]},
```

Then compile the application to retrieve the dependency.

    $ rebar3 compile

## Setting up Dialyzer

Run the following command to get dialyzer initialized.

    $ rebar3 dialyzer

## Write a Simple Handler

Create an `elli_handler` behavior. Mimicking the example documentation, the
following provides a `POST` endpoint.
```
-module(kashi_elli_callback).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-behavior(elli_handler).

handle(Req, _Args) ->
	handle(Req#req.method, elli_request:path(Req), Req).

handle('POST', [<<"bid">>], _Req) ->
	{ok, [], <<"Thank you for your request!">>};

handle(_, _, _Req) ->
	{404, [], <<"Not Found">>}.

handle_event(_Event, _Data, _Args) ->
	ok.
```

This then needs to be wired into the supervisor. Again, mimicking the examples.
```
init([]) ->
  ElliOpts = [{callback, kashi_elli_callback}, {port, 3000}],
  ElliSpec = { kashi_http
             , {elli, start_link, [ElliOpts]}
             , permanent
             , 5000
             , worker
             , [elli]},
  {ok, { {one_for_all, 5, 10}, [ElliSpec]} }.
```

## Start the Project Shell

Run the following to start up the application in a shell.

    $ rebar3 shell

After the shell is started, you can hit the webserver at
[http://localhost:3000](http://localhost:3000).

## Issue a Request

```
curl http://localhost:3000/bid -X POST -H "Content-Type:application/json" \
  -d '{"bid": 0}'
```

## Building a Release

    $ rebar3 release
    $ rebar3 as prod tar
