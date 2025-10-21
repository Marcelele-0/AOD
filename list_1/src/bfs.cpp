#include "bfs.hpp"

// Constructor is identical to DFS
BFS::BFS(const Graph& g) : graph(g) {
    visited.resize(g.num_vertices + 1, false);
    result.parent_tree.resize(g.num_vertices + 1, -1);
}

// run() method is identical to DFS
TraversalResult BFS::run(int start_node) {
    if (start_node >= 1 && start_node <= graph.num_vertices && !visited[start_node]) {
        bfs_iterative(start_node);
    }
    
    for (int i = 1; i <= graph.num_vertices; ++i) {
        if (!visited[i]) {
            bfs_iterative(i);
        }
    }
    return result;
}

// The core of the BFS algorithm
void BFS::bfs_iterative(int start_node) {
    std::queue<int> q;

    q.push(start_node);
    visited[start_node] = true;
    result.visit_order.push_back(start_node);
    // start_node has no parent, so parent_tree[start_node] remains -1

    while (!q.empty()) {
        int u = q.front();
        q.pop();

        for (int v : graph.adj_list[u]) {
            if (!visited[v]) {
                visited[v] = true;
                result.parent_tree[v] = u; // u is the parent of v
                result.visit_order.push_back(v);
                q.push(v); // Add to the queue to visit later
            }
        }
    }
}