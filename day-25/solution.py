import numpy as np

file = open(0)
input_data = (data.split(":") for data in file.readlines())
input_data = ((data[0].strip(), data[1].strip()) for data in input_data)
input_data = ((data[0], set(map(lambda x: x.strip(), data[1].split(" "))))
              for data in input_data)

input_data = dict(input_data)
for key, values in input_data.copy().items():
    for value in values:
        if value not in input_data:
            input_data[value] = {key}
        else:
            input_data[value].add(key)

mapping = list(input_data.keys())

adjM = [[int(j in input_data[i] or i in input_data[j])
         for j in mapping] for i in mapping]
degM = [[0 for _ in mapping] for _ in mapping]

for i, j in enumerate(mapping):
    degM[i][i] = len(input_data[j])


A = np.matrix(adjM)
D = np.matrix(degM)
L = D - A

eigenvalues, eigenvectors = np.linalg.eig(L)

second_smallest_index = np.argsort(eigenvalues)[1]

# Get the corresponding eigenvector
second_smallest_eigenvector = eigenvectors[:, second_smallest_index]

partition = np.sign(second_smallest_eigenvector)

lo = partition.reshape(-1).tolist()[0]

left = (1 for i in lo if i < 0)
right = (1 for i in lo if i >= 0)

print(sum(left) * sum(right))


