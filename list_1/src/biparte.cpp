#include "bipartite.hpp"

/**
 * @brief Constructor: initializes the partition vector.
 */
BipartiteCheck::BipartiteCheck(const Graph& g) : graph(g) {
    // Initialize all vertices as uncolored (-1)
    result.partition.resize(g.num_vertices + 1, -1);
    result.is_bipartite = true; // Assume innocence
}

/**
 * @brief Runs the 2-coloring algorithm on all components.
 */
BipartiteResult BipartiteCheck::run() {
    // Loop through all vertices to handle disconnected graphs
    for (int i = 1; i <= graph.num_vertices; ++i) {
        if (result.partition[i] == -1) { // If uncolored
            // Start coloring this new component with color 0
            bfs_check(i, 0);
        }
        
        // If the last BFS found a conflict, we can stop early
        if (!result.is_bipartite) {
            break;
        }
    }
    return result;
}

/**
 * @brief Core 2-coloring logic using BFS.
 */
void BipartiteCheck::bfs_check(int start_node, int start_color) {
    std::queue<int> q;
    
    q.push(start_node);
    result.partition[start_node] = start_color;

    while (!q.empty()) {
        int u = q.front();
        q.pop();

        int u_color = result.partition[u];
        int neighbor_color = 1 - u_color; // The opposite color

        for (int v : graph.adj_list[u]) {
            if (result.partition[v] == -1) { // Case 1: Neighbor is uncolored
                result.partition[v] = neighbor_color;
                q.push(v);
            } else if (result.partition[v] == u_color) { // Case 2: CONFLICT!
                // The neighbor 'v' has the same color as 'u'.
                // This means we found an odd-length cycle.
                result.is_bipartite = false;
                return; // Exit immediately
            }
            // Case 3: (result.partition[v] == neighbor_color)
            // This is fine, the neighbor already has the correct opposite color.
            // Do nothing.
        }
    }
}