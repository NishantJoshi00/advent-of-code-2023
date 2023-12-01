

solution.o: solution.asm
	nasm -f elf64 solution.asm -o solution.o

solution: solution.o
	ld solution.o -o solution

build: solution

build2: solution2

solution2: solution2.o
	ld solution2.o -o solution2

solution2.o: solution2.asm
	nasm -f elf64 solution2.asm -o solution2.o

run: build
	./solution

clean:
	rm solution.o
	rm solution
