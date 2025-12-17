# Plik: exercise_1_model.jl
include("exercise_1_data.jl")
using Printf

# --- BFS (Szukanie ścieżki w sieci residualnej) ---
function bfs_find_path(adj::Vector{Vector{Edge}}, s::Int, t::Int, parent_edge::Vector{Tuple{Int, Int}})
    fill!(parent_edge, (0, 0)) 
    parent_edge[s] = (-1, -1)
    
    queue = Vector{Int}()
    push!(queue, s)
    
    while !isempty(queue)
        u = popfirst!(queue)
        if u == t return true end
        
        for (i, e) in enumerate(adj[u])
            if parent_edge[e.to] == (0, 0) && (e.cap - e.flow > 0)
                parent_edge[e.to] = (u, i)
                push!(queue, e.to)
            end
        end
    end
    return false
end

# --- Algorytm Edmondsa-Karpa ---
function edmonds_karp(adj::Vector{Vector{Edge}}, s::Int, t::Int)
    max_flow = 0
    augmenting_paths = 0
    n = length(adj)
    parent_edge = Vector{Tuple{Int, Int}}(undef, n)
    
    while bfs_find_path(adj, s, t, parent_edge)
        augmenting_paths += 1
        path_flow = typemax(Int)
        curr = t
        
        while curr != s
            p, idx = parent_edge[curr]
            edge = adj[p][idx]
            path_flow = min(path_flow, edge.cap - edge.flow)
            curr = p
        end
        
        curr = t
        while curr != s
            p, idx = parent_edge[curr]
            adj[p][idx].flow += path_flow
            rev_idx = adj[p][idx].rev
            adj[curr][rev_idx].flow -= path_flow
            curr = p
        end
        max_flow += path_flow
    end
    return max_flow, augmenting_paths
end

# --- Generowanie pliku dla GLPK ---
function save_to_glpk(filename::String, adj::Vector{Vector{Edge}}, s::Int, t::Int)
    open(filename, "w") do f
        println(f, "/* Model Programowania Liniowego dla problemu Max Flow */")
        println(f, "/* Wygenerowano automatycznie przez program exercise_1_model.jl */")
        println(f, "")
        
        # 1. Definicja zmiennych (dla każdej krawędzi u->v)
        # x_u_v reprezentuje przepływ od wierzchołka u do v
        println(f, "/* --- ZMIENNE DECYZYJNE --- */")
        println(f, "/* x_u_v: przepływ na krawędzi z wierzchołka u do v */")
        println(f, "/* Ograniczenia: 0 <= x_u_v <= capacity */")
        
        for u in 1:length(adj)
            for e in adj[u]
                # Zapisujemy tylko krawędzie "w przód" (oryginalne), czyli te z cap > 0
                if e.cap > 0
                    # Indeksy w GLPK zrobimy takie same jak w Julii (1-based)
                    println(f, "var x_$(u)_$(e.to) >= 0, <= $(e.cap);")
                end
            end
        end
        println(f, "")
        
        # 2. Funkcja celu
        println(f, "/* --- FUNKCJA CELU --- */")
        println(f, "/* Maksymalizacja wypływu ze źródła s=$s */")
        print(f, "maximize flow: ")
        
        first = true
        for e in adj[s]
            if e.cap > 0
                if !first print(f, " + ") end
                print(f, "x_$(s)_$(e.to)")
                first = false
            end
        end
        println(f, ";")
        println(f, "")
        
        # 3. Ograniczenia zachowania przepływu (Kirchhoffa)
        println(f, "/* --- OGRANICZENIA ZACHOWANIA PRZEPŁYWU --- */")
        println(f, "/* Suma wpływająca = Suma wypływająca dla każdego v != s, t */")
        
        for u in 1:length(adj)
            if u == s || u == t
                continue
            end
            
            # Wypływ z u: suma x_u_v
            print(f, "s.t. node_$(u): ")
            
            # Suma wyjść
            out_terms = String[]
            for e in adj[u]
                if e.cap > 0
                    push!(out_terms, "x_$(u)_$(e.to)")
                end
            end
            
            # Suma wejść (musimy przeszukać graf lub wiedzieć kto wchodzi)
            # W listach sąsiedztwa nie mamy szybkiej listy "wchodzących", 
            # ale możemy iterować po całym grafie (wolne) LUB wykorzystać krawędzie zwrotne.
            # Krawędź zwrotna u->v (cap=0) oznacza, że istnieje v->u (cap>0).
            in_terms = String[]
            for e in adj[u]
                if e.cap == 0 # To jest krawędź zwrotna dla v->u
                    v = e.to
                    push!(in_terms, "x_$(v)_$(u)")
                end
            end
            
            # Zapis równania: sum(out) - sum(in) = 0
            if isempty(out_terms) && isempty(in_terms)
                # Wierzchołek izolowany? Pomiń
                println(f, "0 = 0;") 
            else
                if !isempty(out_terms)
                    print(f, join(out_terms, " + "))
                else
                    print(f, "0")
                end
                
                print(f, " - (")
                if !isempty(in_terms)
                    print(f, join(in_terms, " + "))
                else
                    print(f, "0")
                end
                println(f, ") = 0;")
            end
        end
        
        println(f, "end;")
    end
end

# --- Funkcja Main (Obsługa argumentów CLI) ---
function main()
    k = 0
    print_flow = false
    glpk_file = ""
    
    idx = 1
    while idx <= length(ARGS)
        if ARGS[idx] == "--size"
            k = parse(Int, ARGS[idx+1])
            idx += 1
        elseif ARGS[idx] == "--printFlow"
            print_flow = true
        elseif ARGS[idx] == "--glpk"
            glpk_file = ARGS[idx+1]
            idx += 1
        end
        idx += 1
    end
    
    if k == 0
        println("Użycie: julia exercise_1_model.jl --size <k> [--printFlow] [--glpk <nazwa_pliku>]")
        return
    end
    
    # 1. Start pomiaru czasu
    start_time_ns = time_ns()
    
    adj = generate_hypercube(k)
    s = 1
    t = 2^k
    
    # Jeśli podano --glpk, generujemy plik PRZED uruchomieniem algorytmu (na czystym grafie)
    # Czas generowania pliku zazwyczaj nie powinien wliczać się do czasu algorytmu, 
    # ale w zadaniu nie jest to sprecyzowane. Wygenerujmy go poza pomiarem.
    if !isempty(glpk_file)
        println(stderr, "Generowanie pliku GLPK: $glpk_file ...")
        save_to_glpk(glpk_file, adj, s, t)
    end

    flow_val, paths_count = edmonds_karp(adj, s, t)
    
    duration = (time_ns() - start_time_ns) / 1e9
    
    println(stdout, flow_val)
    
    if print_flow
        for u in 1:length(adj)
            for e in adj[u]
                if e.cap > 0 && e.flow > 0
                    println(stdout, "$(u-1) -> $(e.to-1): $(e.flow)")
                end
            end
        end
    end
    
    println(stderr, "Czas: $(round(duration, digits=4)) s")
    println(stderr, "Ścieżki: $paths_count")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end