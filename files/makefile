.PHONY: default all clean

default: program
all: default
run: default RUN
test: default TEST

program:
	-clear
	-g++ -Wall -std=c++11 -O3 -g -DDEBUG code.cpp -o code

RUN:
	-clear
	-./code

TEST:
	-clear
	-./code < input

clean:
	-rm -f code