#include "scc.hpp"
#include <functional>

/**
 * @brief Step 2: Creates and returns the transpose graph G_T.
 */
Graph SCC::create_transpose(const Graph& g) {
    // Create an "empty" graph to be filled (use constructor that doesn't read stdin)
    Graph gt(g.num_vertices, g.num_edges, g.directed);

    // Iterate over all edges in G
    for (int u = 1; u <= g.num_vertices; ++u) {
        for (int v : g.adj_list[u]) {
            // Add the reversed edge v -> u to G_T
            gt.adj_list[v].push_back(u); 
        }
    }
    return gt;
}

/**
 * @brief Constructor: immediately creates the transpose graph.
 */
SCC::SCC(const Graph& g) : graph(g) {
    // Step 2 (part 1) - create G_T right away
    this->graph_transpose = create_transpose(g); 
    
    // Initialize the 'visited' vector for Step 3
    this->visited.resize(g.num_vertices + 1, false);
}

/**
 * @brief Step 1: Uses TopoSort to get the vertex order.
 */
std::list<int> SCC::get_processing_order() {
    // Compute finishing order with a plain DFS (don't stop on cycles).
    int n = this->graph.num_vertices;
    std::vector<char> visited_local(n + 1, false);
    std::vector<int> finish_order; // push_back when finishing

    std::function<void(int)> dfs = [&](int u) {
        visited_local[u] = true;
        for (int v : this->graph.adj_list[u]) {
            if (!visited_local[v]) dfs(v);
        }
        finish_order.push_back(u);
    };

    for (int i = 1; i <= n; ++i) {
        if (!visited_local[i]) dfs(i);
    }

    // finish_order has nodes in increasing finish time; we need decreasing
    std::list<int> order;
    for (auto it = finish_order.rbegin(); it != finish_order.rend(); ++it) order.push_back(*it);
    return order;
}

/**
 * @brief Step 3: Simple DFS on G_T.
 */
void SCC::dfs_on_transpose(int u, std::vector<int>& current_component) {
    visited[u] = true;
    current_component.push_back(u);
    
    // Search neighbors in the *transpose* graph
    for (int v : graph_transpose.adj_list[u]) {
        if (!visited[v]) {
            dfs_on_transpose(v, current_component);
        }
    }
}

/**
 * @brief Main method to run Kosaraju's algorithm.
 */
SCCResult SCC::run() {
    // Step 1: Get processing order from TopoSort
    std::list<int> order = get_processing_order();

    // Step 3: Run DFS on G_T using the specified order
    for (int u : order) {
        if (!visited[u]) {
            // 'u' is in a new, undiscovered SCC
            std::vector<int> current_component;
            dfs_on_transpose(u, current_component);
            
            // Save the found component
            result.components.push_back(current_component);
        }
    }
    
    return result;
}