# Autor: Marcel Musiałek
#
# Plik: exercise_6_model.jl
# Rozwiązanie Zadania 6 z listy 2 (AOD) - Kamery

# --- Aktywacja środowiska ---
import Pkg
Pkg.activate(@__DIR__) 

# Instalacja pakietów (jeśli brak)
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

# --- Funkcja pomocnicza ---
# Sprawdza, czy kamera w punkcie (cam_r, cam_c) widzi cel w (target_r, target_c)
# przy zasięgu k (kształt plusa +)
function czy_widzi(cam_r, cam_c, target_r, target_c, k)
    # 1. Czy są w tym samym wierszu I odległość kolumn <= k?
    w_wierszu = (cam_r == target_r) && (abs(cam_c - target_c) <= k)
    
    # 2. Czy są w tej samej kolumnie I odległość wierszy <= k?
    w_kolumnie = (cam_c == target_c) && (abs(cam_r - target_r) <= k)
    
    return w_wierszu || w_kolumnie
end

# --- Główna logika ---

(m, n, kontenery, lista_k) = pobierz_dane_zad6()

println("DANE: Teren $(m)x$(n), Liczba kontenerów: $(length(kontenery))")

for k in lista_k
    println("\n" * "="^40)
    println("   ROZWIĄZYWANIE DLA ZASIĘGU k = $k")
    println("="^40)
    
    model = Model(GLPK.Optimizer)
    
    # Zmienna decyzyjna x[r,c] = 1 jeśli stoi tam kamera, 0 jeśli nie
    @variable(model, x[r=1:m, c=1:n], Bin)
    
    # Funkcja celu: Minimalizacja liczby kamer
    @objective(model, Min, sum(x[r,c] for r in 1:m, c in 1:n))
    
    # Ograniczenie 1: Kamera nie może stać na polu zajętym przez kontener
    for (cr, cc) in kontenery
        @constraint(model, x[cr, cc] == 0)
    end
    
    # Ograniczenie 2: Każdy kontener musi być monitorowany
    # Dla każdego kontenera, suma zmiennych x dla pól, z których go widać, musi być >= 1
    for (cr, cc) in kontenery
        # Tworzymy listę pól (r,c), z których kamera o zasięgu k widzi ten konkretny kontener
        pola_widzace = [(r, c) for r in 1:m, c in 1:n if czy_widzi(r, c, cr, cc, k)]
        
        # Suma kamer na tych polach >= 1
        @constraint(model, sum(x[r, c] for (r, c) in pola_widzace) >= 1)
    end
    
    # Rozwiązanie
    optimize!(model)
    
    # Prezentacja wyników
    if termination_status(model) == MOI.OPTIMAL
        liczba_kamer = round(Int, objective_value(model))
        println("Minimalna liczba kamer: $liczba_kamer")
        
        println("\nMapa rozmieszczenia (K=Kamera, C=Kontener, . = Pusto):")
        
        # Nagłówek kolumn
        print("   ")
        for c in 1:n
            print("$c ")
        end
        println("")
        
        for r in 1:m
            print("$r: ")
            for c in 1:n
                is_camera = value(x[r,c]) > 0.5
                is_container = (r, c) in kontenery
                
                if is_camera
                    print("K ")
                elseif is_container
                    print("C ")
                else
                    print(". ")
                end
            end
            println("")
        end
        
        println("\nLista pozycji kamer:")
        for r in 1:m, c in 1:n
            if value(x[r,c]) > 0.5
                println(" - ($r, $c)")
            end
        end
        
    else
        println("Problem nierozwiązywalny dla k=$k!")
    end
end

println("\n" * "="^40)
println("         KONIEC ZADANIA 6")
println("="^40 * "\n")