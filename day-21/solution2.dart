
import 'dart:io';
import 'dart:core';
import 'dart:math';



(int, int) find_start(List<String> space) {
  for (int i = 0; i < space.length; ++i) {
    for (int j = 0; j < space[i].length; ++j) {
      if (space[i][j] == 'S') {
        return (i, j);
      }
    }
  }
  return (-1, -1);
}

int visit_depth((int, int) start, List<String> graph, int depth, Set<((int, int), int)> visited) {
  if (visited.contains((start, depth))) {
    return 0;
  }
  if (depth == 0) {
    visited.add((start, depth));
    return 1;
  }


  int output = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    .map((current) => (start.$1 + current.$1, start.$2 + current.$2))
    .where((value) => value.$1 >= 0 && value.$1 < graph.length && value.$2 >= 0 && value.$2 < graph[0].length && graph[value.$1][value.$2] != '#')
    .fold(0, (acc, current) => acc + visit_depth(current, graph, depth - 1, visited));

  visited.add((start, depth));

  return output;
}



int main() {
  List<String> input = [];
  String? current = stdin.readLineSync();

  while (current != null) {
    input.add(current.trim());
    current = stdin.readLineSync();
  }

  int size = input.length; 
  int steps = 26501365;

  (int, int) start = find_start(input);

  int grid_width = steps ~/ size - 1;
  num odd = pow(grid_width ~/ 2 * 2 + 1, 2);
  num even = pow((grid_width + 1) ~/ 2 * 2, 2);


  int odd_points = visit_depth(start, input, size * 2 + 1, {});
  int even_points = visit_depth(start, input, size * 2, {});

  int top_c = visit_depth((size - 1, start.$2), input, size - 1, {});
  int right_c = visit_depth((start.$2, 0), input, size - 1, {});
  int bottom_c = visit_depth((0, start.$2), input, size - 1, {});
  int left_c = visit_depth((start.$1, size - 1), input, size - 1, {});

  int tr_t = visit_depth((size - 1, 0), input, size ~/ 2 - 1, {});
  int br_t = visit_depth((0, 0), input, size ~/ 2 - 1, {});
  int tl_t = visit_depth((size - 1, size - 1), input, size ~/ 2 - 1, {});
  int bl_t = visit_depth((0, size - 1), input, size ~/ 2 - 1, {});


  int tr_tr = visit_depth((size - 1, 0), input, (size * 3) ~/ 2 - 1, {});
  int br_tr = visit_depth((0, 0), input, (size * 3) ~/ 2 - 1, {});
  int tl_tr = visit_depth((size - 1, size - 1), input, (size * 3) ~/ 2 - 1, {});
  int bl_tr = visit_depth((0, size - 1), input, (size * 3) ~/ 2 - 1, {});

  num output = 
    (odd * odd_points) + (even * even_points) // Inner Points
    + (top_c + right_c + bottom_c + left_c) // Corner Points
    + (grid_width + 1) * (tr_t + br_t + tl_t + bl_t) // Side triangle points
    + grid_width * (tr_tr + br_tr + tl_tr + bl_tr); // Side (kinda) trapezoidal points

  print(output);
  

  return 0;
}
