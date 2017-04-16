-module(my_db).

-export([start/0, stop/0, write/2, read/1, delete/1, match/1]).
-export([init/0]).

start() ->
  register(my_db, spawn(my_db, init, [])).

init() ->
  loop([]).


stop() ->
  call(quit).

write(Key, Element) ->
  call({write, Key, Element}).

read(Key) ->
  call({read, Key}).

delete(Key) ->
  call({delete, Key}).

match(Element) ->
  call({match, Element}).


call(Msg) ->
  my_db ! {request, self(), Msg},
  receive {reply, Reply} -> Reply end.

loop(Db) ->
  receive
    {request, Pid, {write, K, E}} ->
      NewDb = write(K, E, Db),
      reply(Pid, ok),
      loop(NewDb);
    {request, Pid, {read, K}} ->
      reply(Pid, read(K, Db)),
      loop(Db);
    {request, Pid, {delete, K}} ->
      NewDb = delete(K, Db),
      reply(Pid, ok),
      loop(NewDb);
    {request, Pid, {match, E}} ->
      reply(Pid, match(E, Db)),
      loop(Db)
  end.

reply(Pid, Msg) ->
  Pid ! {reply, Msg}.


write(Key, Element, Db) ->
  lists:keystore(Key, 1, Db, {Key, Element}).

read(Key, Db) ->
  case lists:keyfind(Key, 1, Db) of
    {_, V} -> {ok, V};
    false -> {error, instance}
  end.

delete(Key, Db) ->
  lists:keydelete(Key, 1, Db).

match(Element, Db) ->
  lists:filtermap(fun({K, E}) -> case E of Element -> {true, K}; _ -> false end end, Db).
