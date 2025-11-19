#ifndef AOD_RESULTS_HPP
#define AOD_RESULTS_HPP

#include <list>
#include <vector>

/**
 * @brief A structure to hold the common results of a graph traversal.
 */
struct TraversalResult {
    // The order in which vertices were visited
    std::vector<int> visit_order; 
    
    // The resulting traversal tree (e.g., DFS tree or BFS tree)
    // parent_tree[i] = the parent of vertex i
    std::vector<int> parent_tree; 
};

/**
 * @brief holds the results of a topological sort.
 */
struct TopoSortResult {
    bool has_cycle = false;
    std::list<int> top_order;
};

/**
 * @brief Stores the result of the Strongly Connected Components algorithm.
 * 'components' is a vector of vectors, where each inner vector
 * represents one strongly connected component.
 */
struct SCCResult {
    std::vector<std::vector<int>> components;
};

/**
 * @brief Stores the result of the bipartite graph check.
 */
struct BipartiteResult {
    bool is_bipartite = true; // Assume true until a conflict is found
    
    // Stores the partition (color) for each vertex.
    // -1: uncolored
    //  0: partition V0
    //  1: partition V1
    std::vector<int> partition;
};

#endif // AOD_RESULTS_HPP
