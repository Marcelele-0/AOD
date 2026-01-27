#include <iostream>
#include <string>
#include <vector>
#include <iomanip>

#include "graph.hpp"
#include "utils.hpp"

// Makra preprocesora wybierają algorytm podczas kompilacji
#ifdef ALGO_DIJKSTRA
    #include "algos/dijkstra.hpp"
    #define SOLVE run_dijkstra
    std::string algo_name = "Dijkstra Standard";
#elif defined(ALGO_DIAL)
    #include "algos/dial.hpp"
    #define SOLVE run_dial
    std::string algo_name = "Dijkstra Dial";
#elif defined(ALGO_RADIX)
    #include "algos/radix.hpp"
    #define SOLVE run_radix
    std::string algo_name = "Dijkstra Radix Heap";
#else
    #error "Nie zdefiniowano algorytmu! Uzyj make."
#endif

int main(int argc, char* argv[]) {
    std::string graph_file, ss_source_file, ss_out_file, p2p_file, p2p_out_file;

    // Prosty parser argumentów
    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "-d") graph_file = argv[++i];
        else if (arg == "-ss") ss_source_file = argv[++i];
        else if (arg == "-oss") ss_out_file = argv[++i];
        else if (arg == "-p2p") p2p_file = argv[++i];
        else if (arg == "-op2p") p2p_out_file = argv[++i];
    }

    if (graph_file.empty()) {
        std::cerr << "Uzycie: " << argv[0] << " -d <graf> [-ss <zrodla> -oss <wynik>] [-p2p <pary> -op2p <wynik>]\n";
        return 1;
    }

    std::cout << "Algorytm: " << algo_name << "\n";
    std::cout << "Wczytywanie grafu: " << graph_file << "... ";
    Graph G;
    G.loadFromDIMACS(graph_file);
    std::cout << "Wierzcholkow: " << G.n << ", Lukow: " << G.m << "\n";

    // --- TRYB SS (Single Source) ---
    if (!ss_source_file.empty() && !ss_out_file.empty()) {
        std::cout << "Tryb SS: Wczytywanie zrodel z " << ss_source_file << "...\n";
        auto sources = loadSources(ss_source_file);
        
        double total_time = 0.0;
        
        for (int s : sources) {
            auto start = std::chrono::high_resolution_clock::now();
            
            // --- URUCHOMIENIE ALGORYTMU ---
            auto dists = SOLVE(G, s);
            // -----------------------------
            
            auto end = std::chrono::high_resolution_clock::now();
            std::chrono::duration<double, std::milli> elapsed = end - start;
            total_time += elapsed.count();
        }

        double avg_time = total_time / sources.size();
        std::cout << "Sredni czas SS: " << avg_time << " ms\n";
        
        saveSSResults(ss_out_file, graph_file, ss_source_file, G, avg_time);
        std::cout << "Wyniki zapisano do: " << ss_out_file << "\n";
    }

    // --- TRYB P2P (Point to Point) ---
    if (!p2p_file.empty() && !p2p_out_file.empty()) {
        std::cout << "Tryb P2P: Wczytywanie par z " << p2p_file << "...\n";
        auto queries = loadP2P(p2p_file);
        
        std::vector<std::tuple<int, int, long long>> results;

        for (const auto& q : queries) {
            // W tej wersji uruchamiamy SS dla u i bierzemy dist[v]
            // W praktyce można by przerwać algorytm po znalezieniu v, 
            // ale dla porównania wydajności pełnych algorytmów zwykle liczy się całość.
            // Jeśli chcesz optymalizacji "early exit", musiałbyś zmodyfikować funkcje algos/*.hpp
            // by przyjmowały opcjonalny cel 'target'.
            
            auto dists = SOLVE(G, q.u);
            results.emplace_back(q.u, q.v, dists[q.v]);
        }

        saveP2PResults(p2p_out_file, graph_file, p2p_file, G, results);
        std::cout << "Wyniki zapisano do: " << p2p_out_file << "\n";
    }

    return 0;
}