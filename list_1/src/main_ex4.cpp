#include <iostream>
#include <vector>
#include "graph.hpp"
#include "bipartite.hpp"
#include "algorithm_results.hpp"

int main() {
    // 1. Load the graph
    Graph g;

    // 2. Create the algorithm object and run it
    BipartiteCheck checker(g);
    BipartiteResult res = checker.run();

    // 3. Print the main result (yes/no)
    if (res.is_bipartite) {
        std::cout << "Graf jest dwudzielny." << std::endl;
        
        // 4. Print partitions (if n <= 200)
        if (g.num_vertices <= 200) {
            std::vector<int> V0, V1;
            for (int i = 1; i <= g.num_vertices; ++i) {
                if (res.partition[i] == 0) {
                    V0.push_back(i);
                } else if (res.partition[i] == 1) {
                    V1.push_back(i);
                }
                // Note: if a component has only 1 node, it might stay -1
                // depending on implementation, but for bipartite check
                // we can assign it to V0. Let's adjust logic:
            }
            
            // Re-check for unassigned (single-node components)
            for (int i = 1; i <= g.num_vertices; ++i) {
                 if (res.partition[i] == -1) {
                    V0.push_back(i);
                 }
            }


            std::cout << "Podzial V0: ";
            for (int node : V0) {
                std::cout << node << " ";
            }
            std::cout << std::endl;

            std::cout << "Podzial V1: ";
            for (int node : V1) {
                std::cout << node << " ";
            }
            std::cout << std::endl;
        }

    } else {
        std::cout << "Graf NIE jest dwudzielny." << std::endl;
    }

    // 5. Answer the complexity question
    std::cout << "\nZlozonosc algorytmu: O(|V| + |E|)" << std::endl;

    return 0;
}