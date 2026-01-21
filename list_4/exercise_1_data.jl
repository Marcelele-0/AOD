# Plik: exercise_1_data.jl
using Random

# --- Struktura Krawędzi ---
mutable struct Edge
    to::Int         # Dokąd prowadzi
    rev::Int        # Indeks krawędzi odwrotnej u sąsiada (do sieci residualnej)
    cap::Int        # Pojemność
    flow::Int       # Aktualny przepływ
end

# --- Funkcje pomocnicze do bitów ---
function hamming_weight(x::Int)
    return count_ones(x)
end

function zero_count(x::Int, k::Int)
    return k - count_ones(x)
end

# --- Generowanie Grafu (Hiperkostka) ---
function generate_hypercube(k::Int)
    n = 2^k
    # Lista sąsiedztwa: Tablica tablic krawędzi
    adj = [Vector{Edge}() for _ in 1:n]
    
    # Iterujemy po liczbach od 0 do 2^k - 1
    for u_val in 0:(n-1)
        u_idx = u_val + 1  # Julia indeksuje od 1
        
        # Sprawdzamy każdy bit
        for bit in 0:(k-1)
            # Jeśli bit to 0, możemy go zmienić na 1 (krawędź w górę wagi Hamminga)
            if (u_val >> bit) & 1 == 0
                v_val = u_val | (1 << bit)
                v_idx = v_val + 1
                
                # Obliczanie pojemności wg wzoru z zadania
                # l = max(H(u), Z(u), H(v), Z(v))
                l = max(
                    hamming_weight(u_val), 
                    zero_count(u_val, k),
                    hamming_weight(v_val), 
                    zero_count(v_val, k)
                )
                
                capacity = rand(1:(2^l))
                
                # Dodajemy krawędź "w przód" (u -> v)
                push!(adj[u_idx], Edge(v_idx, length(adj[v_idx]) + 1, capacity, 0))
                
                # Dodajemy krawędź "w tył" (v -> u) z pojemnością 0 (dla sieci residualnej)
                push!(adj[v_idx], Edge(u_idx, length(adj[u_idx]), 0, 0))
            end
        end
    end
    
    return adj
end