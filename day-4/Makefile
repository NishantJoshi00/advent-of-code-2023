
solution.beam: solution.erl
	erl -compile solution.erl

solution2.beam: solution2.erl
	erl -compile solution2.erl

build: solution.beam
build2: solution2.beam

run: solution.beam
	erl -noshell -s solution main -s init stop


run2: solution2.beam
	erl -noshell -s solution2 main -s init stop
