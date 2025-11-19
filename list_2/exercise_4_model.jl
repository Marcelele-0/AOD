# Autor: Marcel Musiałek
#
# Plik: exercise_4_model.jl
# Rozwiązanie Zadania 4(a) i 4(b) z listy 2 (AOD)

# --- 1. Aktywacja środowiska projektu ---
import Pkg
Pkg.activate(@__DIR__) 

# --- 2. Automatyczna instalacja pakietów ---
required_packages = ["JuMP", "GLPK"] 
println("Sprawdzam pakiety...")
for pkg_name in required_packages
    if isnothing(Base.find_package(pkg_name))
        println("Instaluję: $pkg_name")
        Pkg.add(pkg_name)
    end
end
println("Pakiety gotowe.")
# --- Koniec sekcji instalacyjnej ---


# --- 3. Wczytanie pakietów i danych ---
using JuMP
using GLPK
using Printf # Do formatowania liczb

# Dołączenie pliku z obiema funkcjami danych
include("exercise_4_data.jl")


# --- 4. Funkcja rozwiązująca model ---
# Ta funkcja bierze dane jako argumenty i drukuje wyniki
function solve_path_problem(Nodes, Arcs, Costs, Times, StartNode, EndNode, MaxTime, task_name)
    
    println("\n" * "="^40)
    println("           WYNIKI ZADANIA $task_name")
    println("="^40)
    println("Dane: Start: $StartNode, Koniec: $EndNode, Max Czas: $MaxTime")

    model = Model(GLPK.Optimizer)

    @variable(model, x[a in Arcs], Bin)

    @objective(model, Min, 
        sum( Costs[a] * x[a] for a in Arcs )
    )

    @constraint(model, MaxCzas,
        sum( Times[a] * x[a] for a in Arcs ) <= MaxTime
    )

    balance = Dict(k => 0 for k in Nodes)
    balance[StartNode] = 1
    balance[EndNode] = -1

    @constraint(model, Flow[k in Nodes],
        sum( x[a] for a in Arcs if a[1] == k ) - 
        sum( x[a] for a in Arcs if a[2] == k ) 
        == balance[k]
    )

    optimize!(model)

    # --- Prezentacja wyników ---
    if termination_status(model) == MOI.OPTIMAL
        println("\n--- ZNALEZIONO ROZWIĄZANIE OPTYMALNE ---")
        
        @printf("Minimalny koszt ścieżki: %.0f \$\n", objective_value(model))
        
        total_time = sum(Times[a] * value(x[a]) for a in Arcs)
        @printf("Całkowity czas ścieżki: %.0f (Limit: %d)\n", total_time, MaxTime)

        println("\nOptymalna ścieżka (przejścia):")
        
        # Rekonstrukcja ścieżki (bez 'global', bo jesteśmy w funkcji)
        current_node = StartNode
        path_str = "$StartNode"
        
        while current_node != EndNode
            found_next = false
            for a in Arcs
                # Sprawdzamy łuk wychodzący z current_node i wybrany przez solver
                if a[1] == current_node && value(x[a]) > 0.9 
                    path_str *= " -> $(a[2])"    # Modyfikujemy zmienną lokalną
                    current_node = a[2]        # Modyfikujemy zmienną lokalną
                    found_next = true
                    break
                end
            end
            if !found_next
                println("BŁĄD: Ścieżka przerwana - nie znaleziono wyjścia z $current_node")
                break
            end
        end
        println("   ", path_str)
        
    elseif termination_status(model) == MOI.INFEASIBLE
        println("\n--- PROBLEM NIEROZWIĄZYWALNY (INFEASIBLE) ---")
        println("Nie znaleziono ścieżki od $StartNode do $EndNode, która spełniałaby limit czasu $MaxTime.")
    else
        println("\n!!! PROBLEM Z ROZWIĄZANIEM !!!")
        println("Status: ", termination_status(model))
    end
    println("="^40 * "\n")
end # --- Koniec funkcji solve_path_problem ---


# --- 5. Główny skrypt ---
# Teraz wywołujemy funkcję solve_path_problem DWA RAZY,
# raz dla danych z 4(a) i raz dla 4(b).

println("--- Rozpoczynam Zadanie 4(a) ---")
# Wczytujemy dane 4(a)
(N_a, A_a, C_a, T_a, S_a, E_a, M_a) = pobierz_dane_zad4a()
# Rozwiązujemy
solve_path_problem(N_a, A_a, C_a, T_a, S_a, E_a, M_a, "4 (a)")


println("--- Rozpoczynam Zadanie 4(b) ---")
# Wczytujemy dane 4(b)
(N_b, A_b, C_b, T_b, S_b, E_b, M_b) = pobierz_dane_zad4b()
# Rozwiązujemy
solve_path_problem(N_b, A_b, C_b, T_b, S_b, E_b, M_b, "4 (b)")


println("Wszystkie podpunkty Zadania 4 wykonane.")