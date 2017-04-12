-module(echo).

-export([start/0, loop/0, print/1, stop/0]).

start() ->
  register(echo, spawn(echo, loop, [])),
  ok.

loop() ->
  receive
    {_, Msg} ->
      io:format("~w~n", [Msg]),
      loop();
    stop ->
      true
  end.

print(Term) ->
  echo ! {self(), Term},
  ok.

stop() ->
  echo ! stop,
  ok.
