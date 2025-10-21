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
        if (!(std::cin >> type)) {
            std::cerr << "Input error: could not read graph type (expected 'D' or 'U')\n";
            std::exit(1);
        }

        if (!(std::cin >> num_vertices)) {
            std::cerr << "Input error: could not read number of vertices\n";
            std::exit(1);
        }
        if (!(std::cin >> num_edges)) {
            std::cerr << "Input error: could not read number of edges\n";
            std::exit(1);
        }

        directed = (type == 'D');

        // Resize to n+1 to use 1-based indexing (we ignore index 0)
        if (num_vertices < 0) {
            std::cerr << "Input error: number of vertices is negative\n";
            std::exit(1);
        }
        adj_list.clear();
        adj_list.resize(num_vertices + 1);

        for (int i = 0; i < num_edges; ++i) {
            int u, v; // The two vertices of an edge
            if (!(std::cin >> u >> v)) {
                std::cerr << "Input error: expected edge " << (i+1) << " of " << num_edges << " (u v)\n";
                std::exit(1);
            }

            if (u < 1 || u > num_vertices || v < 1 || v > num_vertices) {
                std::cerr << "Input error: edge endpoints out of range: (" << u << ", " << v << ") for n=" << num_vertices << "\n";
                std::exit(1);
            }

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