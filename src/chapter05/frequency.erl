-module(frequency).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).

start() ->
  register(frequency, spawn(frequency, init, [])).

init() ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

get_frequencies() -> [10, 11, 12, 13, 14, 15].

stop() ->
  call(stop).
allocate() ->
  call(allocate).
deallocate(Freq) ->
  call({deallocate, Freq}).

call(Message) ->
  frequency ! {request, self(), Message},
  receive
    {reply, Reply} -> Reply
  end.

loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid, {deallocate, Freq}} ->
      {NewFrequencies, Reply} = deallocate(Frequencies, Freq, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid, stop} ->
      {_, Allocated} = Frequencies,
      case Allocated of
        [] ->
          reply(Pid, ok);
        _ ->
          reply(Pid, {error, need_deallocate_all_frequencies}),
          loop(Frequencies)
      end
  end.

reply(Pid, Reply) ->
  Pid ! {reply, Reply}.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate(Frequencies, Pid) ->
  {[Freq | Free], Allocated} = Frequencies,
  N = length([P || {_K, P} <- Allocated, P == Pid]),
  if
    N < 3 ->
      {{Free, [{Freq, Pid} | Allocated]}, {ok, Freq}};
    true ->
      {Frequencies, {error, exceeded_max_allocated_frequencies}}
  end.


deallocate({Free, Allocated}, Freq, Pid) ->
  io:format("~w~n", [Allocated]),
  case lists:keyfind(Freq, 1, Allocated) of
    {_, Pid} ->
      NewAllocated = lists:keydelete(Freq, 1, Allocated),
      {{[Freq | Free], NewAllocated}, ok};
    {_, OtherPid} ->
      io:format("~w~n", [OtherPid]),
      {{Free, Allocated}, {error, allocated_by_other_pid}};
    false ->
      {{Free, Allocated}, ok}
  end.

