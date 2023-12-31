input = `require("fs").readFileSync(0, "utf8")`;

data = input.trim().split("\n");


reducedNodes = [[0, 1], [data.length  - 1, data[data.length - 1].search /\./]]


for i of data
  for j of data[i]
    if data[i][j] in "."
      x = [[0, 1], [0,-1],[-1, 0],[1,0]].map((inner) -> 
        x = [inner[0] + parseInt(i),inner[1] + parseInt(j) ]

        if x[0] > data.length-1 || x[0] < 0
          return 0

        if x[1] > data[0].length-1 || x[1] < 0
          return 0
        if data[x[0]][x[1]] in ".v><^"
          return 1
        else
          return 0
      ).reduce((acc, x) -> acc + x)
      if x > 2
        reducedNodes.push([parseInt(i), parseInt(j)])

dismap = {}

for i in reducedNodes
  dismap[i[0] * data.length + i[1]] = {}
  dist = 0
  queue = [[i[0], i[1], 0]]
  seen = []
  while queue.length > 0
    [x, y, n] = queue.pop(0)
    if x < 0 || x > data.length - 1
      continue
    if y < 0 || y > data[0].length - 1
      continue
    if data[x][y] == '#'
      continue

    if (x * data.length + y) in seen
      continue

    seen.push(x * data.length + y)
    if reducedNodes.some((element) -> (element[0] == x && element[1] == y) && (element[0] != i[0] && element[1] != i[1]))
      dismap[i[0] * data.length + i[1]][x * data.length + y] = n
    else
      values = []
      switch data[x][y]
        when '>' then values.push([0, 1])
        when '<' then values.push([0, -1])
        when '^' then values.push([-1, 0])
        when 'v' then values.push([1, 0])
        when '.' then [[0, 1], [0,-1],[-1, 0],[1,0]].forEach((inner) -> values.push(inner))
      values.forEach((inner) -> queue.push([inner[0] + x, inner[1]+y, n + 1]))

dfs = (graph, current, seen) -> 
  if current == (data.length - 1) * data.length + (data[0].length - 2)
    return 0
  mySeen = seen.slice()
  mySeen.push(current)
  output = -1
  for key, value of graph[current]
    current = dfs(graph, key, mySeen) + value
    if (output == -1) && (current != -1)
      output = current
      continue
    if (output != -1) && (current != -1) && (current > output)
      output = current
      continue
  return output
  
console.log dfs(dismap, 1, []) + 1
  
