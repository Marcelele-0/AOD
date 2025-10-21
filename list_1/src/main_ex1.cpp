#include <iostream>
#include <string>
#include "graph.h"
#include "dfs.hpp"
#include "bfs.hpp"
#include "results.hpp"

/**
 * @brief Helper function to print results in a clean format.
 * @param method_name The name of the algorithm (e.g., "DFS", "BFS").
 * @param res The TraversalResult object.
 * @param n The total number of vertices.
 * @param print_tree Whether to print the parent tree (as required by the task).
 */
void print_results(const std::string& method_name, 
                   const TraversalResult& res, 
                   int n, bool print_tree) {
    
    // 1. Print the visit order
    std::cout << method_name << " visit order: ";
    for (int node : res.visit_order) {
        std::cout << node << " ";
    }
    std::cout << "\n";

    // 2. Print the tree (if parameter is set)
    if (print_tree) {
        std::cout << method_name << " tree (parent -> child):\n";
        for (int i = 1; i <= n; ++i) {
            if (res.parent_tree[i] != -1) {
                // Print the edge from parent to child
                std::cout << res.parent_tree[i] << " -> " << i << "\n";
            }
        }
    }
}

int main() {
    // 1. Load the graph
    // The Graph constructor automatically reads from std::cin
    Graph g;

    // 2. Set the parameter for printing the tree
    // In a real app, you might get this from command line args.
    bool param_print_tree = true; 
    
    // --- Run DFS ---
    DFS dfs_searcher(g); // Create a new DFS algorithm object
    TraversalResult dfs_res = dfs_searcher.run(1); // Run, starting from vertex 1
    
    print_results("DFS", dfs_res, g.num_vertices, param_print_tree);

    std::cout << "--------------------------------\n";

    // --- Run BFS ---
    // We MUST create a new BFS object to get a "clean" state
    // (i.e., a new 'visited' vector).
    BFS bfs_searcher(g);
    TraversalResult bfs_res = bfs_searcher.run(1);

    print_results("BFS", bfs_res, g.num_vertices, param_print_tree);

    return 0;
}