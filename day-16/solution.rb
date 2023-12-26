module Direction
  LEFT = 0
  RIGHT = 1
  UP = 2
  DOWN = 3
end

input_data = []
output_data = []

def deep_copy2d(input)
  input.map { |s| s.clone }
end

def get_next(current_x, current_y, direction)
  case direction
  when Direction::LEFT
    [current_x - 1, current_y]
  when Direction::RIGHT
    [current_x + 1, current_y]
  when Direction::UP
    [current_x, current_y - 1]
  when Direction::DOWN
    [current_x, current_y + 1]
  end
end

def traverse(input_space, output_space, current_x, current_y, direction)
  if current_y < 0 || current_y >= input_space.length || current_x < 0 || current_x >= input_space[0].length
    return
  end
  verify_bit = (output_space[current_y][current_x] >> direction) & 1
  if verify_bit == 1
    return
  end
  output_space[current_y][current_x] += 1 << direction
  if input_space[current_y][current_x] == "."
    new_x, new_y = get_next(current_x, current_y, direction)
    traverse(input_space, output_space, new_x, new_y, direction)
  elsif input_space[current_y][current_x] == "-"
    case direction
    when Direction::LEFT, Direction::RIGHT
      new_x, new_y = get_next(current_x, current_y, direction)
      traverse(input_space, output_space, new_x, new_y, direction)
    when Direction::UP, Direction::DOWN
      new_x, new_y = get_next(current_x, current_y, Direction::LEFT)

      traverse(input_space, output_space, new_x, new_y, Direction::LEFT)
      new_x, new_y = get_next(current_x, current_y, Direction::RIGHT)

      traverse(input_space, output_space, new_x, new_y, Direction::RIGHT)
    end
  elsif input_space[current_y][current_x] == "/"
    case direction
    when Direction::UP
      new_x, new_y = get_next(current_x, current_y, Direction::RIGHT)

      traverse(input_space, output_space, new_x, new_y, Direction::RIGHT)
    when Direction::DOWN
      new_x, new_y = get_next(current_x, current_y, Direction::LEFT)

      traverse(input_space, output_space, new_x, new_y, Direction::LEFT)
    when Direction::LEFT
      new_x, new_y = get_next(current_x, current_y, Direction::DOWN)

      traverse(input_space, output_space, new_x, new_y, Direction::DOWN)
    when Direction::RIGHT
      new_x, new_y = get_next(current_x, current_y, Direction::UP)
      traverse(input_space, output_space, new_x, new_y, Direction::UP)
    end
  elsif input_space[current_y][current_x] == "\\"
    case direction
    when Direction::UP
      new_x, new_y = get_next(current_x, current_y, Direction::LEFT)
      traverse(input_space, output_space, new_x, new_y, Direction::LEFT)
    when Direction::DOWN
      new_x, new_y = get_next(current_x, current_y, Direction::RIGHT)
      traverse(input_space, output_space, new_x, new_y, Direction::RIGHT)
    when Direction::LEFT
      new_x, new_y = get_next(current_x, current_y, Direction::UP)
      traverse(input_space, output_space, new_x, new_y, Direction::UP)
    when Direction::RIGHT
      new_x, new_y = get_next(current_x, current_y, Direction::DOWN)
      traverse(input_space, output_space, new_x, new_y, Direction::DOWN)
    end
  elsif input_space[current_y][current_x] == "|"
    case direction
    when Direction::UP, Direction::DOWN
      new_x, new_y = get_next(current_x, current_y, direction)
      traverse(input_space, output_space, new_x, new_y, direction)
    when Direction::RIGHT, Direction::LEFT
      new_x, new_y = get_next(current_x, current_y, Direction::UP)
      traverse(input_space, output_space, new_x, new_y, Direction::UP)
      new_x, new_y = get_next(current_x, current_y, Direction::DOWN)
      traverse(input_space, output_space, new_x, new_y, Direction::DOWN)
    end
  end
end

def solve(input, output, current_x, current_y, direction)
  out = deep_copy2d(output)
  traverse(input, out, current_x, current_y, direction)
  out.sum { |x| x.sum { |y| (y == 0) ? 0 : 1 } }
end

while line = gets
  if line.nil?
    break
  end
  input_data.push(line.strip.chars)
  output_data.push(line.strip.chars.map { |_| 0 })
end



# multiple.each(&:join)

puts solve(input_data, output_data, 0, 0, Direction::RIGHT)
