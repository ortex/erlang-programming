-module(ch3).

-export([sum/1, sum/2]).
-export([create/1, reverse_create/1]).
-export([print_n/1, print_odd_n/1]).
-export([filter/2, reverse/1, concatenate/1, flatten/1]).

%% 3.1
sum(0) -> 0;
sum(N) -> N + sum(N - 1).

sum(N, M) -> sum(N, M, 0).

sum(N, N, Sum) -> N + Sum;
sum(N, M, Sum) when N < M -> sum(N + 1, M, Sum + N);
sum(_, _, _) -> error(badarg).


%% 3.2
create(N) -> create(N, []).

create(0, List) -> List;
create(N, List) -> create(N - 1, [N | List]).

%%create(0) -> [];
%%create(N) -> create(N - 1) ++ [N].

reverse_create(0) -> [];
reverse_create(N) -> [N | reverse_create(N - 1)].

%% 3.3
print_n(1) ->
  io:format("Number:~p~n", [1]);
print_n(N) ->
  print_n(N - 1),
  io:format("Number:~p~n", [N]).

print_odd_n(1) ->
  io:format("Number:~p~n", [1]);
print_odd_n(N) when N rem 2 == 1 ->
  print_odd_n(N - 1),
  io:format("Number:~p~n", [N]);
print_odd_n(N) ->
  print_odd_n(N - 1).

%% 3.5

filter([], _) -> [];
filter([H | T], Min) when H =< Min ->
  [H | filter(T, Min)];
filter([_ | T], Min) ->
  filter(T, Min).

reverse(L) -> reverse(L, []).

reverse([], L) -> L;
reverse([H | T], L2) -> reverse(T, [H | L2]).


concatenate([]) -> [];
concatenate([[] | T]) ->
  concatenate(T);
concatenate([[H | Hs] | T]) ->
  [H | concatenate([Hs | T])].

%%concatenate(L) -> concatenate(L, []).
%%concatenate([], R) -> reverse(R);
%%concatenate([[] | T], R) -> concatenate(T, R);
%%concatenate([[H | Hs] | T], R) ->
%%  concatenate([Hs | T], [H | R]).


flatten([]) -> [];
flatten([H | T]) when not(is_list(H)) ->
  [H | flatten(T)];
flatten([H | T]) ->
  flatten(H) ++ flatten(T).

