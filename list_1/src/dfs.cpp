#include "dfs.hpp"

// Constructor initializes the state vectors based on graph size
DFS::DFS(const Graph& g) : graph(g) {
    visited.resize(g.num_vertices + 1, false);
    result.parent_tree.resize(g.num_vertices + 1, -1); // -1 means no parent
}

TraversalResult DFS::run(int start_node) {
    // 1. Start from the specified node (if valid and not visited)
    if (start_node >= 1 && start_node <= graph.num_vertices && !visited[start_node]) {
        dfs_recursive(start_node);
    }
    
    // 2. Iterate through all vertices to find disconnected components
    for (int i = 1; i <= graph.num_vertices; ++i) {
        if (!visited[i]) {
            dfs_recursive(i);
        }
    }
    return result;
}

// The core of the DFS algorithm
void DFS::dfs_recursive(int u) {
    visited[u] = true;
    result.visit_order.push_back(u);

    for (int v : graph.adj_list[u]) {
        if (!visited[v]) {
            result.parent_tree[v] = u; // u is the parent of v
            dfs_recursive(v);
        }
    }
}