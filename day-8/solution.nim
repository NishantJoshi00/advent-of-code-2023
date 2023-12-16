import std/tables
import std/strscans
import std/options


type Decision = tuple[left: string, right: string]
var 
  treeTable = initTable[string, Decision]()
  distanceMap = initTable[string, int]()
  
proc goto(a: Decision, loc: char): string =
  case loc
  of 'R':
    result = a.right
  of 'L':
    result = a.left
  else:
    raise newException(ValueError, "Invalid data while making decision")


proc traverse(target: string, ops: string, distance: int): Option[int] =
  if target == "ZZZ":
    result = some(distance)
  else:
    if len(ops) < 1:
      
      if distanceMap.hasKey(target):
        result = some(distanceMap[target] + distance)
      else:
        result = none(int)
    else:
      var decision = treeTable[target].goto(ops[0])
      result = traverse(decision, ops[1..^1], distance + 1)




let moveSeq = readLine(stdin)
discard readLine(stdin)

while not endOfFile(stdin):
  var 
    input = readLine(stdin)
    target, left, right: string
  if input.scanf("$+ = ($+, $+)", target, left, right):
    treeTable[target] = (left: left, right: right)

while not distanceMap.hasKey("AAA"):
  for target in treeTable.keys:
    var output = traverse(target, moveSeq, 0)
    if output.isSome:
      distanceMap[target] = output.get
    
    


# echo treeTable
# echo distanceMap

echo distanceMap["AAA"]



