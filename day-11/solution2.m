1;

function input_data = generateInput()
  inputLines = {};
  while true
    try
      i = input("", "s");
      inputLines(end+1) = i;
    catch
      break;
    end
  end
  input_data = char(inputLines);
end

function result = duplicateRows(matrix)
  [rows, cols] = size(matrix);

  result = {};

  for i = 1:rows
    if all(matrix(i, :) == '.')
      result(end+1) = matrix(i, :);
    end
      result(end+1) = matrix(i, :);
  end
  result = char(result);
end

function index_array = getIndices(matrix)
  [rows, cols] = size(matrix);

  index_array = {};

  for i = 1:rows
    for j = 1:cols
      if (matrix(i, j) == '#')
        index_array(end+1) = [i, j];
      end
    end
  end
end

function dist = manhattenDist(a, b)
  % disp(a);
  % disp(b);
  % printf("-------------------------------------\n");
  a = cell2mat(a);
  b = cell2mat(b);

  dist = abs(a(1) - b(1)) + abs(a(2) - b(2));
end

function distance = distFromAtoBs(a, bs)
  [row, cols] = size(bs);
  distance = 0;
  for i = 1:cols
    distance = distance + manhattenDist(a, bs(i));
  end
end

function distances = distFromAstoBs(as)
  [row, cols] = size(as);
  distances = 0;
  for i = 1:cols
    distances = distances + distFromAtoBs(as(i), as(i:end));
  end
end

function new_data = makeSize(as, bs, s)
  [rows, cols] = size(as);

  new_data = {};
  for i = 1:cols
    a = cell2mat(as(i));
    b = cell2mat(bs(i));
    new_data(end+1) = [a(1) + (b(1) - a(1)) * (s - 1); a(2) + (b(2) - a(2)) * (s - 1)];
  end
end



input_data = generateInput();

input_data2 = duplicateRows(duplicateRows(input_data)')';

input_data = getIndices(input_data);
printf("\n");
input_data2 = getIndices(input_data2);
printf("\n");
input_data3 = makeSize(input_data, input_data2, 1000000);


% output = distFromAstoBs(input_data);
% output2 = distFromAstoBs(input_data2);
output3 = distFromAstoBs(input_data3);

% disp(output);
% disp(output2);
% disp(output3);
printf("%d", output3);






