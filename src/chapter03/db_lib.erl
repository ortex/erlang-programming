-module(db_lib).

-export([new/0, destroy/1, write/3, read/2, delete/2, match/2]).

new() -> [].
destroy(_) -> ok.

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
