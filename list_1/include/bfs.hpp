#pragma once
#include "graph.h"
#include "traversal_result.h"
#include <vector>
#include <queue> // BFS uses a Queue

class BFS {
public:
    /**
     * @brief Constructor.
     * @param g A const reference to the graph to traverse.
     */
    BFS(const Graph& g);

    /**
     * @brief Runs the BFS algorithm.
     * @param start_node The vertex to start the first traversal from.
     * @return A TraversalResult struct containing the visit order and parent tree.
     */
    TraversalResult run(int start_node = 1);

private:
    // --- INTERNAL ALGORITHM STATE ---
    const Graph& graph;
    std::vector<bool> visited;
    TraversalResult result;
    
    // --- Private iterative helper method ---
    void bfs_iterative(int start_node);
};