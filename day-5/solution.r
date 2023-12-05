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

  function(x) {
    for (i in new_map) {
      if (x >= i[2] && x < i[2] + i[3]) {
        return(x + (i[1] - i[2]))
      }
    }
    x
  }
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
  function(x) {
    for (i in data) {
      x <- make_map(i)(x)
    }
    x
  }
}


applier <- make_transform(total)

output <- max(seeds)
for (i in seeds) {
  new <- applier(i)
  if (new < output) {
    output <- new
  }
}

print(output)
