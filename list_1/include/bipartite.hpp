#pragma once
#include "graph.hpp"
#include "results.hpp"
#include <vector>
#include <queue>

class BipartiteCheck {
public:
    /**
     * @brief Constructor.
     * @param g A const reference to the graph (read-only).
     */
    BipartiteCheck(const Graph& g);

    /**
     * @brief Runs the 2-coloring algorithm.
     * @return A BipartiteResult object.
     */
    BipartiteResult run();

private:
    // --- INTERNAL ALGORITHM STATE ---
    const Graph& graph;
    BipartiteResult result;

    /**
     * @brief Runs BFS on a single component to 2-color it.
     * @param start_node The node to begin the traversal.
     * @param start_color The color to assign to the start_node (0 or 1).
     */
    void bfs_check(int start_node, int start_color);
};