#pragma once
#include <vector>
#include <list>
#include "../graph.hpp"
#include "../utils.hpp"

// Algorytm Diala (Dijkstra na kubełkach)
// Złożoność: O(m + W*n) - gdzie W to waga krawędzi
// Uwaga: Działa wydajnie tylko dla małych wag krawędzi!
std::vector<long long> run_dial(const Graph& g, int s) {
    long long C = g.max_weight;
    
    // Zabezpieczenie przed ogromnymi wagami (np. USA-road-d może mieć duże)
    // Jeśli wagi są ogromne, algorytm Diala jest nieopłacalny/niemożliwy
    if (C > 200000) { 
        // W warunkach laboratoryjnych można rzucić błąd lub fallback
        // Tu dla bezpieczeństwa:
        std::cerr << "Uwaga: Zbyt duze wagi krawedzi dla algorytmu Diala (" << C << ").\n";
    }

    std::vector<long long> dist(g.n, INF);
    dist[s] = 0;

    // Kubełki o rozmiarze C + 1
    // buckets[k] przechowuje wierzchołki o tymczasowym dystansie d, gdzie d % (C+1) == k
    std::vector<std::vector<int>> buckets(C + 1);
    
    buckets[0].push_back(s);
    
    long long idx = 0; // Globalny kursor dystansu
    int processed_count = 0;

    while (processed_count < g.n) {
        // Szukamy pierwszego niepustego kubełka
        // W optymistycznym przypadku przesuwamy się tylko o niewielką wartość
        while (buckets[idx % (C + 1)].empty()) {
            idx++;
            // Warunek stopu, gdyby graf był niespójny i idx uciekł w nieskończoność
            if (idx > dist[s] + (long long)g.n * C && processed_count < g.n) break;
        }
        
        if (buckets[idx % (C + 1)].empty()) break; 

        // Pobieramy wierzchołek
        int u = buckets[idx % (C + 1)].back();
        buckets[idx % (C + 1)].pop_back();

        // Jeśli wyciągamy wierzchołek z kubełka, a jego dystans jest już mniejszy
        // (został zaktualizowany i wrzucony do wcześniejszego kubełka), ignorujemy go
        if (dist[u] < idx) continue;

        processed_count++;

        for (const auto& edge : g.adj[u]) {
            long long new_dist = dist[u] + edge.weight;
            if (new_dist < dist[edge.to]) {
                dist[edge.to] = new_dist;
                buckets[new_dist % (C + 1)].push_back(edge.to);
            }
        }
    }
    return dist;
}