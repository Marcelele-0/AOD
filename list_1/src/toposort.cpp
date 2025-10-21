#include "toposort.hpp"

// Constructor initializes the state vector
TopoSort::TopoSort(const Graph& g) : graph(g) {
    // Initialize all vertices as 'unvisited' (state 0)
    state.resize(g.num_vertices + 1, 0); 
}

TopoSortResult TopoSort::run() {
    // Iterate through all vertices to handle disconnected graphs
    for (int i = 1; i <= graph.num_vertices; ++i) {
        if (state[i] == 0 && !result.has_cycle) {
            topo_dfs_recursive(i);
        }
    }
    return result;
}

// "Heart" of the algorithm: DFS with 3 states
void TopoSort::topo_dfs_recursive(int u) {
    // If we already found a cycle, we can stop further searching
    if (result.has_cycle) return;

    // 1. Mark as "visiting" (on recursion stack)
    state[u] = 1; 

    for (int v : graph.adj_list[u]) {
        if (state[v] == 0) { // Unvisited
            topo_dfs_recursive(v);
        } else if (state[v] == 1) { 
            // !! CYCLE DETECTED !!
            // We're trying to visit a vertex that is already on the stack.
            result.has_cycle = true;
            return;
        }
        // If state[v] == 2 (visited), ignore - it's a cross edge
    }

    // 2. Mark as "visited" (leaving the recursion stack)
    state[u] = 2; 
    
    // 3. Add vertex to the FRONT of the result list
    result.top_order.push_front(u);
}