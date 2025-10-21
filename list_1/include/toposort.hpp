#pragma once
#include "graph.hpp"
#include "results.hpp"
#include <vector>

class TopoSort {
public:
    /**
     * @brief Constructor.
     * @param g Constant reference to the graph (read-only).
     */
    TopoSort(const Graph& g);

    /**
     * @brief Runs the topological sorting algorithm.
     * @return TopoSortResult object.
     */
    TopoSortResult run();

private:
    // --- INTERNAL ALGORITHM STATE ---
    const Graph& graph;
    
    // State vector for cycle detection (DFS)
    // 0: unvisited
    // 1: visiting (on recursion stack)
    // 2: visited
    std::vector<int> state; 
    
    TopoSortResult result; // Object in which we build the result

    // --- Private recursive method ---
    void topo_dfs_recursive(int u);
};