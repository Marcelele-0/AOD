#pragma once
#include <vector>
#include <string>
#include <fstream>
#include <iostream>
#include <chrono>
#include "graph.hpp"

// Stała nieskończoności
const long long INF = std::numeric_limits<long long>::max();

// Struktura do zapytań P2P
struct QueryP2P {
    int u, v;
};

// --- WCZYTYWANIE PLIKÓW POMOCNICZYCH ---

std::vector<int> loadSources(const std::string& filename) {
    std::vector<int> sources;
    std::ifstream file(filename);
    char type;
    std::string line;
    while(file >> type) {
        if(type == 's') {
            int s;
            file >> s;
            sources.push_back(s - 1); // 0-based
        } else if(type == 'p') { // p aux sp ss <num>
             std::getline(file, line);
        } else {
             std::getline(file, line);
        }
    }
    return sources;
}

std::vector<QueryP2P> loadP2P(const std::string& filename) {
    std::vector<QueryP2P> queries;
    std::ifstream file(filename);
    char type;
    std::string line;
    while(file >> type) {
        if(type == 'q') {
            int u, v;
            file >> u >> v;
            queries.push_back({u - 1, v - 1});
        } else if (type == 'p') {
            std::getline(file, line);
        } else {
            std::getline(file, line);
        }
    }
    return queries;
}

// --- ZAPIS WYNIKÓW ---

void saveSSResults(const std::string& filename, 
                   const std::string& graph_file, 
                   const std::string& source_file,
                   const Graph& g, 
                   double avg_time_ms) {
    std::ofstream out(filename);
    out << "p res sp ss dijkstra\n";
    out << "f " << graph_file << " " << source_file << "\n";
    out << "g " << g.n << " " << g.m << " 0 " << g.max_weight << "\n";
    out << "t " << avg_time_ms << "\n";
    out.close();
}

void saveP2PResults(const std::string& filename,
                    const std::string& graph_file,
                    const std::string& p2p_file,
                    const Graph& g,
                    const std::vector<std::tuple<int, int, long long>>& results) {
    std::ofstream out(filename);
    out << "f " << graph_file << " " << p2p_file << "\n";
    out << "g " << g.n << " " << g.m << " 0 " << g.max_weight << "\n";
    for(const auto& res : results) {
        // Zapisujemy indeksy +1 (format DIMACS)
        out << "d " << std::get<0>(res) + 1 << " " << std::get<1>(res) + 1 << " " << std::get<2>(res) << "\n";
    }
    out.close();
}