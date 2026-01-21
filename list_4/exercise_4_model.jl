# Plik: exercise_4_model.jl
# Implementacja Algorytmu Dinica O(V^2 E)

include("exercise_1_data.jl") # Potrzebujemy struktury Edge

# --- BFS: Buduje graf warstwowy (oblicza poziomy) ---
function bfs_dinic(adj::Vector{Vector{Edge}}, s::Int, t::Int, level::Vector{Int})
    fill!(level, -1)
    level[s] = 0
    queue = Vector{Int}()
    push!(queue, s)
    
    while !isempty(queue)
        u = popfirst!(queue)
        for e in adj[u]
            # Jeśli krawędź ma wolną przepustowość i wierzchołek nieodwiedzony
            if e.cap - e.flow > 0 && level[e.to] == -1
                level[e.to] = level[u] + 1
                push!(queue, e.to)
            end
        end
    end
    return level[t] != -1
end

# --- DFS: Szuka potoku blokującego ---
function dfs_dinic(adj::Vector{Vector{Edge}}, u::Int, t::Int, pushed::Int, level::Vector{Int}, ptr::Vector{Int})
    if pushed == 0 || u == t
        return pushed
    end
    
    # Pętla od ostatnio sprawdzonej krawędzi (ptr[u])
    for i in ptr[u]:length(adj[u])
        ptr[u] = i # Aktualizacja wskaźnika (Current Arc Optimization)
        e = adj[u][i]
        
        # Warunek: wierzchołek docelowy jest na kolejnej warstwie i jest wolne miejsce
        if level[u] + 1 != level[e.to] || e.cap - e.flow == 0
            continue
        end
        
        tr = dfs_dinic(adj, e.to, t, min(pushed, e.cap - e.flow), level, ptr)
        
        if tr == 0
            continue
        end
        
        # Aktualizacja przepływów
        adj[u][i].flow += tr
        adj[e.to][e.rev].flow -= tr
        
        return tr
    end
    
    return 0
end

# --- Główna funkcja Dinica ---
function dinic_algorithm(adj::Vector{Vector{Edge}}, s::Int, t::Int)
    max_flow = 0
    n = length(adj)
    level = Vector{Int}(undef, n)
    ptr = Vector{Int}(undef, n)
    
    # Dopóki da się dojść do ujścia w grafie residualnym (budujemy graf warstwowy)
    while bfs_dinic(adj, s, t, level)
        fill!(ptr, 1) # Reset wskaźników na początek list sąsiedztwa
        
        while true
            # Szukamy ścieżki w grafie warstwowym
            pushed = dfs_dinic(adj, s, t, typemax(Int), level, ptr)
            if pushed == 0
                break
            end
            max_flow += pushed
        end
    end
    
    return max_flow
end

# Wrapper dla zachowania kompatybilności przy testach (zwraca też "liczba faz" jako dummy stats)
function dinic_wrapper(adj::Vector{Vector{Edge}}, s::Int, t::Int)
    start = time_ns()
    f = dinic_algorithm(adj, s, t)
    dur = (time_ns() - start) / 1e9
    return f, dur
end