# Plik: exercise_3_verification.jl
# Weryfikacja (EK vs GLPK) z eksportem do CSV dla LaTeXa

import Pkg
required = ["JuMP", "GLPK", "CSV", "DataFrames"]
for pkg in required
    if isnothing(Base.find_package(pkg))
        Pkg.add(pkg)
    end
end

using JuMP
using GLPK
using CSV
using DataFrames

include("exercise_1_model.jl")
include("exercise_2_model.jl")

# --- Funkcja rozwiązująca przez JuMP (GLPK) ---
function solve_with_jump(adj::Vector{Vector{Edge}}, s::Int, t::Int)
    n = length(adj)
    model = Model(GLPK.Optimizer)
    set_silent(model)
    
    # Słownik zmiennych przepływu
    flow_vars = Dict{Tuple{Int, Int}, VariableRef}()
    
    for u in 1:n
        for e in adj[u]
            if e.cap > 0
                if !haskey(flow_vars, (u, e.to))
                    flow_vars[(u, e.to)] = @variable(model, lower_bound=0, upper_bound=e.cap)
                end
            end
        end
    end
    
    # Cel: Max wypływ z s
    out_s = [flow_vars[(s, v)] for v in 1:n if haskey(flow_vars, (s, v))]
    @objective(model, Max, sum(out_s))
    
    # Ograniczenia: Kirchhoff
    for u in 1:n
        if u == s || u == t continue end
        
        out_expr = sum([flow_vars[(u, v)] for v in 1:n if haskey(flow_vars, (u, v))]; init=0)
        in_expr  = sum([flow_vars[(v, u)] for v in 1:n if haskey(flow_vars, (v, u))]; init=0)
        
        @constraint(model, in_expr == out_expr)
    end
    
    optimize!(model)
    return termination_status(model) == MOI.OPTIMAL ? objective_value(model) : -1.0
end

# --- Główna funkcja generująca CSV ---
function run_verification_csv()
    results_file = "wyniki_weryfikacja.csv"
    println("Rozpoczynam weryfikację i generowanie $results_file ...")
    
    # Tworzymy pusty DataFrame
    df = DataFrame(
        k = Int[], 
        problem = String[], 
        param = String[], 
        res_ek = Int[], 
        res_lp = Float64[], 
        status = String[]
    )
    
    # 1. Hiperkostka (k=1..5)
    for k in 1:5
        adj = generate_hypercube(k)
        val_ek, _ = edmonds_karp(adj, 1, 2^k)
        val_lp = solve_with_jump(adj, 1, 2^k)
        
        status = abs(val_ek - val_lp) < 1e-5 ? "OK" : "BLAD"
        push!(df, (k, "Hiperkostka", "-", val_ek, val_lp, status))
        print(".")
    end
    
    # 2. Skojarzenia (k=3..5)
    for k in 3:5
        # Sprawdzamy kilka wariantów i
        for i_deg in [1, 2, k]
            adj, s, t = generate_bipartite_graph(k, i_deg)
            val_ek, _ = edmonds_karp(adj, s, t)
            val_lp = solve_with_jump(adj, s, t)
            
            status = abs(val_ek - val_lp) < 1e-5 ? "OK" : "BLAD"
            push!(df, (k, "Skojarzenia", "i=$i_deg", val_ek, val_lp, status))
            print(".")
        end
    end
    
    # Zapis do CSV
    CSV.write(results_file, df)
    println("\nGotowe! Wyniki zapisane w $results_file")
end

run_verification_csv()