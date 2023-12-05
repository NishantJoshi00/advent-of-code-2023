input <- strsplit(readLines(file("stdin")), "\n")



convert_to_number_array <- function(val) {
  as.numeric(strsplit(trimws(val), " ")[[1]])
}


single_transform <- function(num, x) {
  if (num >= x[2] && num < x[2] + x[3]) {
    num + (x[1] - x[2])
  } else {
    num
  }
}

make_map <- function(dataset) {
  # _ <- dataset[[1]]

  old_map <- dataset[-1]

  new_map <- c()

  for (i in old_map) {
    new_map <- c(new_map, list(convert_to_number_array(i)))
  }
  new_map
}


data <- strsplit(input[[1]], ":")[[1]][-1]
seeds <- convert_to_number_array(data)


rest <- input[-1][-1]
total <- c()
new_rest <- c()
for (i in rest) {
  if (length(i) != 0) {
    new_rest <- append(new_rest, i)
  } else {
    total <- c(total, list(new_rest))
    new_rest <- c()
  }
}



make_transform <- function(data) {
  output <- c()
  for (i in data) {
    output <- c(output, list(make_map(i)))
  }
  output
}

applier <-
  make_transform(total)


generate_seeds <- function(data) {
  output <- c()
  for (i in seq(from = 1, to = length(data), by = 2)) {
    seqn <- c(data[i], data[i + 1] + data[i] - 1)
    output <- c(output, list(seqn))
  }
  output
}


# Applying all the functions on the parition giving set of partition
operate <- function(partition, functions) {

}

# (2 10)
# (20 0 5)

set_maker <- function(partition, func) {
  if (length(func) == 0) {
    return(list(partition))
  }
  output <- c()
  unchanged <- c()
  inner <- func[[1]]
  rest <- func[-1]
  p_left <- partition[1]
  p_right <- partition[1] + partition[2] - 1
  i_left <- inner[2]
  i_right <- inner[2] + inner[3] - 1

  # This is messed up because the list are not processed properly
  if (p_left <= i_left && p_right <= i_right) {
    unchanged <- c(unchanged, list(c(p_left, i_left - p_left)))
    output <- c(output, list(c(inner[1], p_right - i_left)))
  } else if (i_left <= p_left && i_right <= p_right) {
    unchanged <- c(unchanged, list(c(i_right + 1, p_right - i_right)))
    output <- c(output, list(c(inner[1] - i_left + p_right + 1), i_right - p_left))
  } else if (i_left <= p_left && p_right <= i_right) {
    output <- c(output, list(c(inner[1] - i_left + p_left), partition[2]))
  } else if (p_left <= i_left && i_right <= p_right) {
    unchanged <- c(
      unchanged, list(c(p_left, i_left - p_left)),
      list(c(i_right + 1, p_right - i_right))
    )
    output <- c(output, list(c(inner[1], inner[3])))
  } else {
    unchanged <- c(unchanged, list(c(partition)))
  }

  for (i in unchanged) {
    data <- set_maker(i, rest)
  }
  output
}

print(c(1, c(list(1, 2))))
