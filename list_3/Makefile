CXX = g++
CXXFLAGS = -O3 -std=c++17 -Wall -Wextra -pedantic

# Cele
all: dijkstra dial radixheap

dijkstra: src/main.cpp src/graph.hpp src/utils.hpp src/algos/dijkstra.hpp
	$(CXX) $(CXXFLAGS) -DALGO_DIJKSTRA -o dijkstra src/main.cpp

dial: src/main.cpp src/graph.hpp src/utils.hpp src/algos/dial.hpp
	$(CXX) $(CXXFLAGS) -DALGO_DIAL -o dial src/main.cpp

radixheap: src/main.cpp src/graph.hpp src/utils.hpp src/algos/radix.hpp
	$(CXX) $(CXXFLAGS) -DALGO_RADIX -o radixheap src/main.cpp

clean:
	rm -f dijkstra dial radixheap

.PHONY: all clean