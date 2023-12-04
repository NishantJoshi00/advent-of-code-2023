-module(solution).
-export([main/0]).

main() -> start(0).

start(Total) ->
    case io:get_line("") of
        eof ->
            io:format("~p~n", [Total]);
        Input ->
            Output = solve(string:trim(Input)),
            start(Total + Output)
    end.

solve(Input) -> 
  [_, Right] = lists:map(fun string:trim/1, string:split(Input, ":")),
  [Lookup, Rest] = lists:map(fun splitNumber/1, lists:map(fun string:trim/1, string:split(Right, " | "))),
  LookupSet = sets:from_list(Lookup),
  operate(LookupSet, Rest, 0).


splitNumber(Input) -> lists:map(fun(X) -> {Int, _} = string:to_integer(X), Int end, re:split(Input, "\s+")).

operate(_, [], Value) -> Value;
operate(Set, [Fst | Rst], Value) -> 
  State = sets:is_element(Fst, Set),
  if 
    State -> 
      if
        Value == 0 -> operate(Set, Rst, 1);
        true -> operate(Set, Rst, Value * 2)
      end;
    true -> operate(Set, Rst, Value)
  end.
