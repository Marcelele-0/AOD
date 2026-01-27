#pragma once
#include <vector>
#include <queue>
#include "../graph.hpp"
#include "../utils.hpp"

// Standardowy Dijkstra z kolejką priorytetową
std::vector<long long> run_dijkstra(const Graph& g, int s) {
    std::vector<long long> dist(g.n, INF);
    dist[s] = 0;

    // pair<dystans, wierzcholek>, greater dla min-heap
    using P = std::pair<long long, int>;
    std::priority_queue<P, std::vector<P>, std::greater<P>> pq;

    pq.push({0, s});

    while (!pq.empty()) {
        long long d = pq.top().first;
        int u = pq.top().second;
        pq.pop();

        if (d > dist[u]) continue;

        for (const auto& edge : g.adj[u]) {
            if (dist[u] + edge.weight < dist[edge.to]) {
                dist[edge.to] = dist[u] + edge.weight;
                pq.push({dist[edge.to], edge.to});
            }
        }
    }
    return dist;
}