# Plik: exercise_4_experiments.jl
# Porównanie: Edmonds-Karp vs Dinic

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

# Import obu algorytmów
include("exercise_1_model.jl") # Edmonds-Karp
include("exercise_4_model.jl") # Dinic

# Funkcja do resetowania przepływów w grafie (żeby użyć tego samego grafu dla obu algorytmów)
function reset_flow!(adj::Vector{Vector{Edge}})
    for u in 1:length(adj)
        for e in adj[u]
            e.flow = 0
        end
    end
end

function run_comparison()
    results_file = "wyniki_porownanie_ek_dinic.csv"
    REPETITIONS = 3 # Dinic jest szybki, ale EK wolny dla k=16, więc 3 starczą
    
    # Zakres testów - uwaga: k=16 dla EK trwa minutę, więc zróbmy do 15 dla szybkich testów, 
    # albo do 16 jeśli masz cierpliwość (Dinic zrobi k=16 w sekundę).
    # Ustawmy 1:16, bo Dinic pokaże pazur przy dużych k.
    ks_range = 1:16
    
    open(results_file, "w") do f
        println(f, "k,time_ek,time_dinic")
    end
    
    df_res = DataFrame(k=Int[], t_ek=Float64[], t_dinic=Float64[])
    
    println("==========================================")
    println(" PORÓWNANIE ALGORYTMÓW (EK vs DINIC)")
    println("==========================================")
    
    for k in ks_range
        print("k = $k ")
        
        sum_ek = 0.0
        sum_dinic = 0.0
        
        for r in 1:REPETITIONS
            GC.gc()
            adj = generate_hypercube(k)
            s = 1
            t = 2^k
            
            # 1. Test Edmonds-Karp
            # Dla bardzo dużych k EK może trwać długo, więc można dodać warunek
            # if k <= 14 ... ale policzmy wszystko dla rzetelności.
            t_start = time_ns()
            edmonds_karp(adj, s, t)
            sum_ek += (time_ns() - t_start) / 1e9
            
            # 2. Reset i Test Dinic
            reset_flow!(adj)
            
            t_start = time_ns()
            dinic_algorithm(adj, s, t)
            sum_dinic += (time_ns() - t_start) / 1e9
            
            print(".")
        end
        
        avg_ek = sum_ek / REPETITIONS
        avg_dinic = sum_dinic / REPETITIONS
        
        push!(df_res, (k, avg_ek, avg_dinic))
        
        open(results_file, "a") do f
            println(f, "$k,$avg_ek,$avg_dinic")
        end
        
        @printf(" OK! EK: %.4fs | Dinic: %.4fs\n", avg_ek, avg_dinic)
    end
    
    println("\nGenerowanie wykresu porównawczego...")
    
    # Wykres Logarytmiczny
    p = plot(
        df_res.k, [df_res.t_ek, df_res.t_dinic],
        label=["Edmonds-Karp" "Dinic"],
        xlabel="Wymiar hiperkostki (k)",
        ylabel="Czas [s] (log)",
        title="Porównanie wydajności: EK vs Dinic",
        yscale=:log10,
        marker=[:circle :square],
        lw=2,
        legend=:topleft
    )
    savefig(p, "wykres_porownanie.png")
    println("Gotowe! Zapisano wykres_porownanie.png")
end

run_comparison()