#include <iostream>
#include "graph.h"
#include "toposort.h"
#include "toposort_result.h"

int main() {
    // 1. Read the graph (done by the constructor)
    Graph g;

    // 2. Check if the graph is directed
    if (!g.directed) {
        std::cerr << "Error: Topological sorting is defined only for directed graphs." << std::endl;
        return 1; // Exit with error
    }

    // 3. Create the algorithm object and run it
    TopoSort sorter(g);
    TopoSortResult res = sorter.run();

    // 4. Print results according to task specification
    if (res.has_cycle) {
        std::cout << "The graph contains a directed cycle." << std::endl;
    } else {
        std::cout << "The graph is acyclic." << std::endl;
        
        // Condition: print order only for n <= 200
        if (g.num_vertices <= 200) {
            std::cout << "Topological order: ";
            for (int node : res.top_order) {
                std::cout << node << " ";
            }
            std::cout << std::endl;
        }
    }

    return 0;
}