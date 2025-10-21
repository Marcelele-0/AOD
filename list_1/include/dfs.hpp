#pragma once
#include "graph.h"
#include "traversal_result.h"
#include <vector>

class DFS {
public:
    /**
     * @brief Constructor.
     * @param g A const reference to the graph to traverse.
     */
    DFS(const Graph& g);

    /**
     * @brief Runs the DFS algorithm.
     * @param start_node The vertex to start the first traversal from.
     * @return A TraversalResult struct containing the visit order and parent tree.
     */
    TraversalResult run(int start_node = 1);

private:
    // --- INTERNAL ALGORITHM STATE ---
    const Graph& graph; // Read-only reference to the graph
    std::vector<bool> visited;
    TraversalResult result;
    
    // --- Private recursive helper method ---
    void dfs_recursive(int u);
};