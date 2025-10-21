#pragma once
#include "graph.hpp"
#include "results.hpp"
#include "toposort.hpp" // Key: We reuse TopoSort for Step 1
#include <vector>
#include <list>

class SCC {
public:
    /**
     * @brief Constructor.
     * @param g A const reference to the graph (read-only).
     */
    SCC(const Graph& g);

    /**
     * @brief Runs Kosaraju's algorithm.
     * @return An SCCResult object containing all components.
     */
    SCCResult run();

private:
    // --- INTERNAL ALGORITHM STATE ---
    const Graph& graph;      // The original graph G
    Graph graph_transpose; // The transposed graph G_T
    std::vector<bool> visited;
    SCCResult result;

    // --- Helper Methods ---

    /**
     * @brief Step 1: Gets the vertex processing order
     * (by reusing our TopoSort algorithm).
     */
    std::list<int> get_processing_order();

    /**
     * @brief Step 2: Creates the transpose graph (G_T).
     */
    Graph create_transpose(const Graph& g);
    
    /**
     * @brief Step 3: A simple DFS on G_T to collect components.
     */
    void dfs_on_transpose(int u, std::vector<int>& current_component);
};