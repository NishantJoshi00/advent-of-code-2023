

# function with the following configuration
# @params:
# hold_time: ms
# total_time: ms
# @output:
# distance travelled
function game(hold_time, total_time)
  hold_time * (total_time - hold_time)
end


# The function solves for a single pair of input i.e. the time given and the best distance recorded
function solve(time, distance)
  left = 0
  right = div(time, 2)
  if game(right, time) < distance
    return 0
  end
  current = div(right + left, 2)
  while left != right && left + 1 != right
    current = div(right + left, 2)
    if game(current, time) <= distance
      left = current
      current = current + 1
    else
      right = current
    end
  end

  if time % 2 == 0
    return (div(time, 2) - current + 1) * 2 - 1
  else
    return (div(time, 2) - current + 1) * 2
  end
end



function main()
  time = split(chomp(readline()))
  time = parse.(Int, time[2:end])
  distance = split(chomp(readline()))
  distance = parse.(Int, distance[2:end])
  output = [solve(i[1], i[2]) for i in zip(time, distance)]
  print(prod(output))
end


main()












