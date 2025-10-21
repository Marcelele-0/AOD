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