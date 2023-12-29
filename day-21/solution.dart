
import 'dart:io';
import 'dart:core';



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

  (int, int) start = find_start(input);
  print(visit_depth(start, input, 64, Set()));

  return 0;
}
