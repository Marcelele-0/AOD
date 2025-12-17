# Plik: run_experiments_avg.jl
# Wersja z PRECYZYJNYM POMIAREM CZASU (nanosekundy)

import Pkg
required_packages = ["Plots", "CSV", "DataFrames"]
for pkg in required_packages
    if isnothing(Base.find_package(pkg))
        Pkg.add(pkg)
    end
end

using Plots
using CSV
using DataFrames
include("exercise_1_model.jl") 

function run_full_suite()
    results_file = "wyniki_srednie_k1_16.csv"
    REPETITIONS = 5
    
    ks = Int[]
    avg_flows = Float64[]
    avg_paths = Float64[]
    avg_times = Float64[]
    
    open(results_file, "w") do f
        println(f, "k,avg_max_flow,avg_paths,avg_time")
    end
    
    println("\n==================================================")
    println(" START ZADANIE 1 ")
    println("==================================================")
    
    for k in 1:16
        print("k = $k ")
        
        sum_flow = 0.0
        sum_paths = 0.0
        sum_time = 0.0
        
        for i in 1:REPETITIONS
            GC.gc() 
            
            # --- ZMIANA: Nanosekundy ---
            t_start_ns = time_ns()
            
            adj = generate_hypercube(k)
            f_val, p_count = edmonds_karp(adj, 1, 2^k)
            
            # Konwersja ns -> s
            duration = (time_ns() - t_start_ns) / 1.0e9
            
            sum_time += duration
            sum_flow += f_val
            sum_paths += p_count
            print(".")
        end
        
        a_flow = sum_flow / REPETITIONS
        a_path = sum_paths / REPETITIONS
        a_time = sum_time / REPETITIONS
        
        push!(ks, k)
        push!(avg_flows, a_flow)
        push!(avg_paths, a_path)
        push!(avg_times, a_time)
        
        open(results_file, "a") do f
            println(f, "$k,$a_flow,$a_path,$a_time")
        end
        
        println(" OK! ($(round(a_time, digits=6)) s)")
    end
    
    println("\nGeneruję wykresy...")
    default(titlefont=10, guidefont=9, legendfontsize=8, lw=2)

    # Wykres Czasu (Log)
    p1 = plot(ks, avg_times, 
        label="Czas obliczeń [s]",
        xlabel="Wymiar k", ylabel="Czas [s] (log)",
        title="Zależność czasu od k",
        yscale=:log10, marker=:circle, color=:red, legend=:topleft
    )
    savefig(p1, "wykres_czas_log.png")

    # Wykres Przepływu (Log)
    p2 = plot(ks, avg_flows, 
        label="Śr. Max Flow",
        xlabel="Wymiar k", ylabel="Przepływ (log)",
        title="Średnia wartość przepływu",
        yscale=:log10, marker=:square, color=:blue, legend=:topleft
    )
    savefig(p2, "wykres_flow_log.png")

    # Wykres Ścieżek
    p3 = plot(ks, avg_paths, 
        label="Liczba ścieżek",
        xlabel="Wymiar k", ylabel="Liczba",
        title="Liczba ścieżek powiększających",
        marker=:diamond, color=:green, legend=:topleft
    )
    savefig(p3, "wykres_sciezki.png")
    
    println("GOTOWE.")
end

run_full_suite()