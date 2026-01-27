#pragma once

#include <vector>
#include <cmath>
#include <algorithm>
#include <limits>
#include "../graph.hpp"
#include "../utils.hpp"

/**
 * Funkcja pomocnicza obliczająca indeks kubełka.
 * Bazuje na pozycji najbardziej znaczącego bitu (MSB) różnicy
 * między aktualnym dystansem a ostatnio wyjętym dystansem.
 *
 * Używa wbudowanej instrukcji procesora __builtin_clzll (Count Leading Zeros)
 * dostępnej w kompilatorach GCC/Clang dla maksymalnej wydajności.
 */
inline int get_bucket_index(long long dist, long long last_dist) {
    long long diff = dist ^ last_dist;
    if (diff == 0) return 0;
    // 64 - liczba zer wiodących daje pozycję MSB + 1.
    // Dla typu long long (64 bit) kubełków będzie maksymalnie 65.
    return 64 - __builtin_clzll(diff); 
}

/**
 * Implementacja algorytmu Radix Heap.
 * * Złożoność: O(m + n log C), gdzie C to maksymalna waga krawędzi.
 * Algorytm zoptymalizowany dla wag całkowitoliczbowych.
 */
std::vector<long long> run_radix(const Graph& g, int s) {
    // Inicjalizacja odległości nieskończonością
    std::vector<long long> dist(g.n, INF);
    dist[s] = 0;

    // Struktura kubełkowa.
    // buckets[i] przechowuje wierzchołki u, dla których zakres odległości
    // pasuje do i-tego bitu różnicy względem last_dist.
    // Rozmiar 65 jest wystarczający dla 64-bitowych liczb (long long).
    std::vector<std::vector<int>> buckets(65);
    
    // Wstawienie źródła do kubełka 0 (diff = 0)
    buckets[get_bucket_index(0, 0)].push_back(s);

    long long last_dist = 0; // Ostatnia wyjęta minimalna odległość (rosnąca monotonicznie)
    int elements_in_heap = 1; // Licznik elementów w strukturze

    while (elements_in_heap > 0) {
        // 1. Znajdź pierwszy niepusty kubełek
        int i = 0;
        while (i < 65 && buckets[i].empty()) {
            i++;
        }
        
        // Zabezpieczenie na wypadek pustego stogu (teoretycznie obsłużone przez while)
        if (i == 65) break;

        // 2. Redystrybucja (jeśli najmniejszy element nie jest w buckets[0])
        // Elementy z buckets[i] są przenoszone do niższych kubełków
        // w oparciu o nowe, zaktualizowane last_dist.
        if (i > 0) {
            // Przenosimy zawartość kubełka do zmiennej lokalnej (std::swap).
            // Dzięki temu buckets[i] staje się puste, co zapobiega unieważnieniu
            // iteratorów podczas ponownego wstawiania elementów (fix na Segmentation Fault).
            std::vector<int> current_bucket;
            std::swap(current_bucket, buckets[i]);
            
            long long min_val = INF;

            // Szukamy nowego minimum w obecnym kubełku
            // Ignorujemy "duchy" (wierzchołki ze starą etykietą, które zostały już poprawione)
            for (int u : current_bucket) {
                if (dist[u] < last_dist) continue; // Pomiń nieaktualne wpisy
                if (dist[u] < min_val) min_val = dist[u];
            }

            // Jeśli znaleziono poprawne minimum (kubełek nie składał się z samych duchów)
            if (min_val != INF) {
                last_dist = min_val; // Aktualizacja monotoniczna
                
                // Rozrzucamy elementy do nowych (niższych) kubełków
                for (int u : current_bucket) {
                    // Ponowna filtracja duchów przy wstawianiu
                    if (dist[u] < last_dist) {
                        elements_in_heap--; // Usuwamy ducha z licznika
                        continue; 
                    }
                    
                    int new_idx = get_bucket_index(dist[u], last_dist);
                    buckets[new_idx].push_back(u);
                }
            } else {
                // Jeśli w kubełku były same duchy, po prostu zmniejszamy licznik
                elements_in_heap -= current_bucket.size();
            }
            
            // Po redystrybucji minimum na pewno trafiło do buckets[0],
            // więc restartujemy pętlę szukania od zera.
            i = 0; 
        }

        // 3. Pobranie elementu z buckets[0]
        // Upewniamy się, że kubełek nie jest pusty (mogło się tak zdarzyć, jeśli przy redystrybucji były same duchy)
        if (buckets[0].empty()) continue;

        int u = buckets[0].back();
        buckets[0].pop_back();
        elements_in_heap--;

        // Ostateczna weryfikacja leniwego usuwania (lazy deletion check)
        if (dist[u] < last_dist) continue;

        // 4. Relaksacja krawędzi wychodzących
        for (const auto& edge : g.adj[u]) {
            long long new_dist = dist[u] + edge.weight;
            
            if (new_dist < dist[edge.to]) {
                dist[edge.to] = new_dist;
                
                // Wstawiamy do odpowiedniego kubełka względem bieżącego last_dist
                int idx = get_bucket_index(new_dist, last_dist);
                buckets[idx].push_back(edge.to);
                elements_in_heap++;
            }
        }
    }

    return dist;
}