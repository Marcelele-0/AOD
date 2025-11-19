# Autor: Marcel Musiałek
#
# Plik: exercise_6_model.jl
# Rozwiązanie Zadania 6 z listy 2 (AOD) - Kamery (Wariant Plus i Kwadrat)

import Pkg
Pkg.activate(@__DIR__) 

required_packages = ["JuMP", "GLPK"] 
for pkg_name in required_packages
    if isnothing(Base.find_package(pkg_name))
        Pkg.add(pkg_name)
    end
end

using JuMP
using GLPK
using Printf

include("exercise_6_data.jl")

# --- Funkcja pomocnicza (Zaktualizowana) ---
# ksztalt: "PLUS" (tylko osie) lub "KWADRAT" (pełny blok 2k+1 x 2k+1)
function czy_widzi(cam_r, cam_c, target_r, target_c, k, ksztalt)
    row_dist = abs(cam_r - target_r)
    col_dist = abs(cam_c - target_c)
    
    if ksztalt == "PLUS"
        # 1. Ten sam wiersz i bliska kolumna LUB Ta sama kolumna i bliski wiersz
        return (cam_r == target_r && col_dist <= k) || (cam_c == target_c && row_dist <= k)
    
    elseif ksztalt == "KWADRAT"
        # 2. Bliski wiersz I bliska kolumna (wnętrze kwadratu)
        return (row_dist <= k) && (col_dist <= k)
    end
    return false
end

# --- Główna logika ---

(m, n, kontenery, lista_k) = pobierz_dane_zad6()
warianty_ksztaltu = ["PLUS", "KWADRAT"]

println("DANE: Teren $(m)x$(n), Liczba kontenerów: $(length(kontenery))")

for ksztalt in warianty_ksztaltu
    for k in lista_k
        println("\n" * "="^50)
        println("   ROZWIĄZYWANIE: KSZTAŁT = $ksztalt, ZASIĘG k = $k")
        println("="^50)
        
        model = Model(GLPK.Optimizer)
        
        @variable(model, x[r=1:m, c=1:n], Bin)
        @objective(model, Min, sum(x[r,c] for r in 1:m, c in 1:n))
        
        # Ogr 1: Nie na kontenerze
        for (cr, cc) in kontenery
            @constraint(model, x[cr, cc] == 0)
        end
        
        # Ogr 2: Pokrycie (z uwzględnieniem kształtu)
        for (cr, cc) in kontenery
            pola_widzace = [(r, c) for r in 1:m, c in 1:n if czy_widzi(r, c, cr, cc, k, ksztalt)]
            @constraint(model, sum(x[r, c] for (r, c) in pola_widzace) >= 1)
        end
        
        optimize!(model)
        
        if termination_status(model) == MOI.OPTIMAL
            liczba_kamer = round(Int, objective_value(model))
            println("Minimalna liczba kamer: $liczba_kamer")
            
            println("\nMapa ($ksztalt, k=$k):")
            print("   ")
            for c in 1:n print("$c ") end
            println("")
            
            for r in 1:m
                print("$r: ")
                for c in 1:n
                    if value(x[r,c]) > 0.5
                        print("K ")
                    elseif (r, c) in kontenery
                        print("C ")
                    else
                        print(". ")
                    end
                end
                println("")
            end
             # Wypisz koordynaty kamer
             println("Lista kamer:")
             for r in 1:m, c in 1:n
                 if value(x[r,c]) > 0.5
                     println(" - ($r, $c)")
                 end
             end

        else
            println("Brak rozwiązania!")
        end
    end
end

println("\n" * "="^40)
println("         KONIEC ZADANIA 6")
println("="^40 * "\n")