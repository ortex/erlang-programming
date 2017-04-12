-module(ring).

-export([start/3, init/2]).

start(M, N, Msg) ->
  Pid = spawn(ring, init, [N, self()]),
  send_m_times(M, Pid, Msg),
  receive
    _ ->
      Pid ! stop
  end.

init(1, FPid) ->
  receive_and_send_next(1, FPid);

init(N, FPid) ->
  Pid = spawn(ring, init, [N - 1, FPid]),
  receive_and_send_next(N, Pid).

receive_and_send_next(N, Next) ->
  receive
    {_, Msg} ->
      io:format("~w: ~w~n", [N, Msg]),
      Next ! {self(), Msg},
      receive_and_send_next(N, Next);
    stop ->
      Next ! stop,
      true
  end.

send_m_times(0, _, _) ->
  ok;

send_m_times(M, Pid, Msg) ->
  Pid ! {self(), Msg},
  io:format("left ~w times to send~n", [M]),
  send_m_times(M - 1, Pid, Msg).
