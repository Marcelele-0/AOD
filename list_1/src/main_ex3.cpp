#include <iostream>
#include "graph.hpp"
#include "scc.hpp"
#include "results.hpp"

int main() {
    // 1. Load the graph
    Graph g;

    // 2. Check if the graph is directed
    if (!g.directed) {
        std::cerr << "Error: SCC algorithm is for directed graphs." << std::endl;
        return 1; // Exit with an error
    }

    // 3. Create the algorithm object and run it
    SCC scc_finder(g);
    SCCResult res = scc_finder.run();


    // 4. Print results (clear, machine- and human-readable)
    std::cout << "SCC count: " << res.components.size() << std::endl;

    // Print sizes of each SCC
    std::cout << "SCC sizes: ";
    for (const auto& comp : res.components) {
        std::cout << comp.size() << " ";
    }
    std::cout << std::endl;

    // Condition: print component contents only for n <= 200 (keep existing behaviour)
    if (g.num_vertices <= 200) {
        std::cout << "--- Components ---" << std::endl;
        int component_index = 1;
        for (const auto& comp : res.components) {
            std::cout << "Component " << component_index++ << ": ";
            for (int node : comp) {
                std::cout << node << " ";
            }
            std::cout << std::endl;
        }
    }

    return 0;
}