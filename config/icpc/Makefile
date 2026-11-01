CXX := clang++
CXXFLAGS := -std=c++20 -O2 -Wall -Wextra
main: code.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
.PHONY: clean
clean:
	rm -f main
