#pragma once
#include <vector>
#include <list>
#include <cmath>
#include <algorithm>
#include "../graph.hpp"
#include "../utils.hpp"

// Funkcja pomocnicza: Oblicza pozycję MSB (Most Significant Bit) różnicy
// Używamy wbudowanej funkcji GCC __builtin_clzll dla szybkości
inline int get_bucket_index(long long dist, long long last_dist) {
    long long diff = dist ^ last_dist;
    if (diff == 0) return 0;
    // __builtin_clzll zwraca liczbę zer wiodących. 
    // 63 - clz to indeks najwyższego ustawionego bitu (dla long long)
    // Dodajemy 1, bo kubełek 0 jest dla równych wartości.
    return 64 - __builtin_clzll(diff); 
}

std::vector<long long> run_radix(const Graph& g, int s) {
    std::vector<long long> dist(g.n, INF);
    dist[s] = 0;

    // Kubełki. Dla 64-bitowych intów max 65 kubełków wystarczy
    // Bucket[0] trzyma wierzchołki o d == last_dist
    std::vector<std::vector<int>> buckets(65);
    
    // Inicjalizacja: wrzucamy źródło do odpowiedniego kubełka
    // Na początku last_dist = 0
    buckets[get_bucket_index(0, 0)].push_back(s);

    long long last_dist = 0;
    int elements_in_heap = 1;

    while (elements_in_heap > 0) {
        // 1. Znajdź pierwszy niepusty kubełek
        int i = 0;
        while (i < 65 && buckets[i].empty()) {
            i++;
        }
        
        if (i == 65) break; // Pusty heap

        // 2. Jeśli najmniejszy kubełek to nie 0 (czyli bucket[0] jest pusty),
        // musimy przenieść elementy z buckets[i] do niższych kubełków (Redistribution)
        if (i > 0) {
            long long min_val = INF;
            // Szukamy nowego minimum w tym kubełku
            for (int u : buckets[i]) {
                if (dist[u] < min_val) min_val = dist[u];
            }
            
            last_dist = min_val; // Aktualizujemy monotonicznie rosnący last_dist
            
            // Przenosimy elementy
            for (int u : buckets[i]) {
                int new_idx = get_bucket_index(dist[u], last_dist);
                buckets[new_idx].push_back(u);
            }
            buckets[i].clear();
            
            // Po redystrybucji na pewno coś trafiło do bucket[0] (element z min_val)
            i = 0; 
        }

        // 3. Wyjmij element z bucket[0] (mający najmniejszy klucz = last_dist)
        int u = buckets[0].back();
        buckets[0].pop_back();
        elements_in_heap--;

        // Jeśli wyjęliśmy coś, co już ma lepszą drogę (lazy deletion), skip
        // W Radix Heap to rzadkie przy poprawnej redystrybucji, ale możliwe
        if (dist[u] < last_dist) continue;

        // 4. Relaksacja
        for (const auto& edge : g.adj[u]) {
            long long new_dist = dist[u] + edge.weight;
            if (new_dist < dist[edge.to]) {
                dist[edge.to] = new_dist;
                int idx = get_bucket_index(new_dist, last_dist);
                buckets[idx].push_back(edge.to);
                elements_in_heap++;
            }
        }
    }
    return dist;
}