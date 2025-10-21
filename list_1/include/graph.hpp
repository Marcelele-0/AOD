#pragma once
#include <vector>
#include <iostream>

class Graph {
public:
    int num_vertices;
    int num_edges;
    bool directed;
    
    // The adjacency list implementation
    // adj_list[i] stores a vector of neighbors for vertex i
    std::vector<std::vector<int>> adj_list;

    /**
     * @brief Constructor that reads graph definition from std::cin.
     * Assumes 1-based vertex numbering (vertices 1...n).
     */
    Graph() {
        char type; // 'D' or 'U'
        std::cin >> type;
        std::cin >> num_vertices >> num_edges;
        
        directed = (type == 'D');

        // Resize to n+1 to use 1-based indexing (we ignore index 0)
        adj_list.resize(num_vertices + 1); 

        for (int i = 0; i < num_edges; ++i) {
            int u, v; // The two vertices of an edge
            std::cin >> u >> v;
            
            adj_list[u].push_back(v); 
            
            if (!directed) {
                // If undirected, add the reverse edge
                adj_list[v].push_back(u);
            }
        }
    }

    /**
     * @brief Construct an empty graph with given sizes (no stdin read).
     * @param n number of vertices
     * @param m number of edges (optional/info)
     * @param is_directed whether the graph is directed
     */
    Graph(int n, int m, bool is_directed) {
        num_vertices = n;
        num_edges = m;
        directed = is_directed;
        adj_list.clear();
        adj_list.resize(num_vertices + 1);
    }
};