-module(solution2).
-export([main/0]).

main() -> start([]).

start(Total) ->
    case io:get_line("") of
        eof ->
            io:format("~p~n", [complete(lists:map(fun(X) -> [1, X] end, Total), 0)]);
            
        Input ->
            [Cnt, _] = solve(string:trim(Input)),
            start(Total ++ [Cnt])
    end.

solve(Input) -> 
  [_, Right] = lists:map(fun string:trim/1, string:split(Input, ":")),
  [Lookup, Rest] = lists:map(fun splitNumber/1, lists:map(fun string:trim/1, string:split(Right, " | "))),
  LookupSet = sets:from_list(Lookup),
  Count = operate(LookupSet, Rest, 0),
  [Count, Rest].


splitNumber(Input) -> lists:map(fun(X) -> {Int, _} = string:to_integer(X), Int end, re:split(Input, "\s+")).


operate(_, [], Value) -> Value;
operate(Set, [Fst | Rst], Value) -> 
  State = sets:is_element(Fst, Set),
  if 
    State -> operate(Set, Rst, Value + 1);
    true -> operate(Set, Rst, Value)
  end.


complete([], Val) -> Val;
complete([[Cnt, _]], Val) -> Val + Cnt;
complete([[Cnt, Itr] | Rst], Val) -> 
  Value = sumAdd(Rst, Itr, Cnt),
  complete(Value, Val + Cnt).


sumAdd(Array, Count, Add) ->
  case Count of
     0 -> Array;
     _Else -> 
       [[Ctr, El] | Rst] = Array,
       [[Ctr + Add, El]] ++ sumAdd(Rst, Count - 1, Add)
  end.
