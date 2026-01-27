#pragma once
#include <vector>
#include <string>
#include <fstream>
#include <iostream>
#include <limits>

struct Edge {
    int to;
    long long weight;
};

struct Graph {
    int n = 0; // Liczba wierzchołków
    int m = 0; // Liczba łuków
    long long max_weight = 0; // Potrzebne do algorytmu Diala
    std::vector<std::vector<Edge>> adj;

    // Wczytywanie formatu DIMACS
    void loadFromDIMACS(const std::string& filename) {
        std::ifstream file(filename);
        if (!file.is_open()) {
            std::cerr << "Blad: Nie mozna otworzyc pliku grafu: " << filename << "\n";
            exit(1);
        }

        char type;
        std::string line;

        while (file >> type) {
            if (type == 'c') {
                std::getline(file, line); // Ignoruj komentarze
            } else if (type == 'p') {
                std::string tmp;
                file >> tmp >> n >> m; // p sp n m
                adj.assign(n, std::vector<Edge>());
            } else if (type == 'a') {
                int u, v;
                long long w;
                file >> u >> v >> w;
                // DIMACS indeksuje od 1, my od 0
                adj[u - 1].push_back({v - 1, w});
                if (w > max_weight) max_weight = w;
            }
        }
        file.close();
    }
};