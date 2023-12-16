import std/tables
import std/strscans
import std/sequtils
import std/strutils
import std/options


type Decision = tuple[left: string, right: string]
var 
  treeTable = initTable[string, Decision]()
  
proc goto(a: Decision, loc: char): string =
  case loc
  of 'R':
    result = a.right
  of 'L':
    result = a.left
  else:
    raise newException(ValueError, "Invalid data while making decision")


proc first_triversal(target: string, ops: string, distance: int): (int, string) =
  if target.endsWith("Z"):
    result = (distance, target)
  else:
    if len(ops) < 1:
      result = (distance, target)
    else:
      var decision = treeTable[target].goto(ops[0])
      result = first_triversal(decision, ops[1..^1], distance + 1)


proc traverse_A(target: string, ops: string): (int, string) =
  var new_target = target;
  var dist = 0;
  while not new_target.endsWith("Z"):
    (dist, new_target) = first_triversal(new_target, ops, dist);
  return (dist, new_target)
    
proc traverse_target(start: string, ops: string, target: string, distance: int, original_ops: string): int =
  if start == target and distance != 0:
    result = distance
  else:
    if len(ops) < 1:
      var decision = start
      result = traverse_target(decision, original_ops, target, distance, original_ops)
    else:
      var decision = treeTable[start].goto(ops[0])
      result = traverse_target(decision, ops[1..^1], target, distance + 1, original_ops)

proc gcd(u, v: int): auto =
  var
    u = u
    v = v
  while v != 0:
    u = u %% v
    swap u, v
  abs(u)

proc lcm(a, b: int): auto = abs(a * b) div gcd(a, b)
    

let moveSeq = readLine(stdin)
discard readLine(stdin)

while not endOfFile(stdin):
  var 
    input = readLine(stdin)
    target, left, right: string
  if input.scanf("$+ = ($+, $+)", target, left, right):
    treeTable[target] = (left: left, right: right)


echo treeTable.keys.toSeq
        .filterIt(it.endsWith("A"))
        .map(proc (input: string): auto = traverse_A(input, moveSeq))
        .map(proc (data: (int, string)): string = data[1])
        .map(proc (data: string): int = 
          traverse_target(data, moveSeq, data, 0, moveSeq)
        )
        .foldl(lcm(a, b))

