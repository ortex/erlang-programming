-module(db).

-export([new/0, destroy/1, write/3, read/2, delete/2, match/2]).

new() -> [].

destroy(_) -> ok.

write(Key, Element, []) ->
  [{Key, Element}];
write(Key, Element, [{Key, _} | TailDb]) ->
  [{Key, Element} | TailDb];
write(Key, Element, [H | T]) ->
  [H | write(Key, Element, T)].

read(_, []) ->
  {error, instanse};
read(Key, [{Key, Value} | _]) ->
  {ok, Value};
read(Key, [_ | TailDb]) ->
  read(Key, TailDb).

delete(_, []) ->
  [];
delete(Key, [{Key, _} | TailDb]) ->
  TailDb;
delete(Key, [H | T]) ->
  [H | delete(Key, T)].

match(_, []) ->
  [];
match(Element, [{Key, Element} | TailDb]) ->
  [Key | match(Element, TailDb)];
match(Element, [_ | TailDb]) ->
  match(Element, TailDb).


