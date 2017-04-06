-module(ch3).

-export([sum/1, sum/2]).
-export([create/1, reverse_create/1]).
-export([print_n/1, print_odd_n/1]).

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

