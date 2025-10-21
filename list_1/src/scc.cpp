#include "scc.hpp"

/**
 * @brief Step 2: Creates and returns the transpose graph G_T.
 */
Graph SCC::create_transpose(const Graph& g) {
    // Create an "empty" graph to be filled
    Graph gt; 
    gt.num_vertices = g.num_vertices;
    gt.num_edges = g.num_edges;
    gt.directed = g.directed;
    gt.adj_list.resize(g.num_vertices + 1);

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
    // We run TopoSort on the *original* graph G
    TopoSort sorter(this->graph);
    TopoSortResult topo_res = sorter.run();
    
    // The 'top_order' list is exactly what we need:
    // vertices sorted by decreasing finishing times.
    return topo_res.top_order;
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