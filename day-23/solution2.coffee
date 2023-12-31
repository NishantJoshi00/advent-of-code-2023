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
  stack = [[i[0], i[1], 0]]
  seen = [i[0] * data.length + i[1]]

  while stack.length > 0
    [x, y, n] = stack.pop()
    if n != 0 && reducedNodes.some((element) -> (element[0] == x && element[1] == y))
      dismap[i[0] * data.length + i[1]][x * data.length + y] = n
      continue


    for inner in [[-1, 0], [1, 0], [0, -1], [0, 1]]
      next_x = x + inner[0]
      next_y = y + inner[1]

      if next_x >= 0 && next_x < data.length && next_y >= 0 && next_y < data[0].length && data[next_x][next_y] != '#' && !seen.some((el) => el == (next_x * data.length + next_y))
        stack.push([next_x, next_y, n + 1])
        seen.push(next_x * data.length + next_y)


dfs = (graph, current, seen) -> 
  if parseInt(current) == (data.length - 1) * data.length + (data[0].length - 2)
    return 0
  output = -1000000000000000
  seen.push(parseInt(current))

  for key, value of graph[current]
    if !seen.some((el) -> el == parseInt(key))
      cur = dfs(graph, parseInt(key), seen) + value
      if cur > output
        output = cur
  seen.pop()


  return output

console.log dfs(dismap, 1, [])
  
