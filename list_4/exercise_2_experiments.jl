# Plik: exercise_2_experiments.jl
# Wersja z PRECYZYJNYM POMIAREM CZASU (nanosekundy)

import Pkg
required = ["Plots", "CSV", "DataFrames"]
for pkg in required
    if isnothing(Base.find_package(pkg))
        Pkg.add(pkg)
    end
end

using Plots
using CSV
using DataFrames
include("exercise_2_model.jl")

function run_z2_experiments()
    results_file = "wyniki_zadanie2.csv"
    REPETITIONS = 10 
    
    range_k = 3:10
    
    open(results_file, "w") do f
        println(f, "k,i,avg_matching,avg_time")
    end
    
    data_log = DataFrame(k=Int[], i=Int[], match=Float64[], time=Float64[])
    
    println("==========================================")
    println(" START ZADANIE 2 ")
    println("==========================================")
    
    for k in range_k
        print("Przetwarzanie k = $k ... ")
        for i_degree in 1:k
            
            sum_match = 0.0
            sum_time = 0.0
            
            for r in 1:REPETITIONS
                # --- ZMIANA: Nanosekundy ---
                start_ns = time_ns()
                
                adj, s, t = generate_bipartite_graph(k, i_degree)
                match_size, _ = edmonds_karp(adj, s, t)
                
                duration = (time_ns() - start_ns) / 1.0e9
                
                sum_time += duration
                sum_match += match_size
            end
            
            avg_m = sum_match / REPETITIONS
            avg_t = sum_time / REPETITIONS
            
            open(results_file, "a") do f
                println(f, "$k,$i_degree,$avg_m,$avg_t")
            end
            push!(data_log, (k, i_degree, avg_m, avg_t))
        end
        println("OK!")
    end
    
    println("\nGenerowanie wykresów...")
    default(titlefont=10, guidefont=9, legendfontsize=8, lw=2)
    
    # Wykres 1
    p1 = plot(
        title="Wielkość skojarzenia od stopnia i",
        xlabel="Stopień wierzchołka (i)", ylabel="Śr. skojarzenie",
        legend=:bottomright
    )
    for k_val in range_k
        sub_df = filter(row -> row.k == k_val, data_log)
        plot!(p1, sub_df.i, sub_df.match, label="k=$k_val", marker=:circle, markersize=3)
    end
    savefig(p1, "wykres_z2_matching.png")
    
    # Wykres 2
    p2 = plot(
        title="Czas działania od k",
        xlabel="Wymiar k", ylabel="Czas [s] (log)",
        yscale=:log10, legend=:topleft
    )
    
    df_i2 = filter(row -> row.i == 2, data_log)
    plot!(p2, df_i2.k, df_i2.time, label="i=2", marker=:square, color=:blue)
    
    df_ik = filter(row -> row.i == row.k, data_log)
    plot!(p2, df_ik.k, df_ik.time, label="i=k", marker=:star5, color=:red)
    
    savefig(p2, "wykres_z2_czas.png")
    
    println("Gotowe.")
end

run_z2_experiments()