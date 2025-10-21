#pragma once
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