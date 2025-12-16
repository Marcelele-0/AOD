# Plik: exercise_2_model.jl
# Rozwiązanie Zadania 2 z obsługą generowania modelu GLPK

include("exercise_1_model.jl") # Importujemy funkcje: edmonds_karp, save_to_glpk
using Random

# --- Generowanie Grafu Dwudzielnego ---
function generate_bipartite_graph(k::Int, i_degree::Int)
    num_nodes_per_set = 2^k
    N = num_nodes_per_set
    total_nodes = 2 * N + 2
    source = 1
    sink = total_nodes
    adj = [Vector{Edge}() for _ in 1:total_nodes]
    
    # S -> V1
    for v1_idx in 2:(N+1)
        push!(adj[source], Edge(v1_idx, length(adj[v1_idx]) + 1, 1, 0))
        push!(adj[v1_idx], Edge(source, length(adj[source]), 0, 0))
    end
    
    # V2 -> T
    for v2_idx in (N+2):(2*N+1)
        push!(adj[v2_idx], Edge(sink, length(adj[sink]) + 1, 1, 0))
        push!(adj[sink], Edge(v2_idx, length(adj[v2_idx]), 0, 0))
    end
    
    # V1 -> V2
    v2_range_start = N + 2
    v2_range_end = 2 * N + 1
    for u in 2:(N+1)
        chosen_neighbors = Set{Int}()
        while length(chosen_neighbors) < i_degree
            push!(chosen_neighbors, rand(v2_range_start:v2_range_end))
        end
        for v in chosen_neighbors
            push!(adj[u], Edge(v, length(adj[v]) + 1, 1, 0))
            push!(adj[v], Edge(u, length(adj[u]), 0, 0))
        end
    end
    return adj, source, sink
end

# --- Funkcja Main dla Zadania 2 ---
function main_z2()
    k = 0
    i_degree = 0
    print_matching = false
    glpk_file = ""
    
    idx = 1
    while idx <= length(ARGS)
        if ARGS[idx] == "--size"
            k = parse(Int, ARGS[idx+1])
            idx += 1
        elseif ARGS[idx] == "--degree"
            i_degree = parse(Int, ARGS[idx+1])
            idx += 1
        elseif ARGS[idx] == "--printMatching"
            print_matching = true
        elseif ARGS[idx] == "--glpk"
            glpk_file = ARGS[idx+1]
            idx += 1
        end
        idx += 1
    end
    
    if k == 0 || i_degree == 0
        println("Użycie: julia exercise_2_model.jl --size <k> --degree <i> [--printMatching] [--glpk <plik>]")
        return
    end
    
    start_ns = time_ns()
    
    adj, s, t = generate_bipartite_graph(k, i_degree)
    
    # Generowanie LP przed uruchomieniem algorytmu
    if !isempty(glpk_file)
        println(stderr, "Generowanie pliku GLPK (Skojarzenie -> MaxFlow): $glpk_file ...")
        save_to_glpk(glpk_file, adj, s, t)
    end

    max_matching_size, _ = edmonds_karp(adj, s, t)
    
    duration = (time_ns() - start_ns) / 1e9
    
    println(stdout, max_matching_size)
    
    if print_matching
        println(stdout, "Skojarzone pary (V1 -> V2):")
        N = 2^k
        for u in 2:(N+1)
            for e in adj[u]
                if e.to > (N+1) && e.to < (2*N+2) && e.flow == 1
                    v1_local = u - 1
                    v2_local = e.to - (N + 1)
                    println(stdout, "($v1_local, $v2_local)")
                end
            end
        end
    end
    
    println(stderr, "Czas: $(round(duration, digits=4)) s")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main_z2()
end