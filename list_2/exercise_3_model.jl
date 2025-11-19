# Autor: Marcel Musiałek
#
# Plik: exercise_3_model.jl
# Rozwiązanie Zadania 3 z listy 2 (AOD)

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
using Printf # Do ładnego formatowania liczb (np. z separatorem tysięcy)

# Dołączenie pliku z danymi
include("exercise_3_data.jl")

# Pobranie danych
(Okresy, K, koszt_norm, limit_ponad, koszt_ponad, popyt, 
 limit_prod_norm, limit_magazyn, koszt_magazyn, magazyn_pocz) = pobierz_dane_zad3()

println("Dane wczytane. Rozpoczynam budowę modelu...")


# --- 4. Budowa modelu ---
model_zad3 = Model(GLPK.Optimizer)

# --- Zmienne decyzyjne ---
# pj - produkcja normalna w okresie j (nieujemna)
@variable(model_zad3, p[j in Okresy] >= 0)

# ej - produkcja ponadwymiarowa w okresie j (nieujemna)
@variable(model_zad3, e[j in Okresy] >= 0)

# mj - magazyn na KONIEC okresu j (nieujemna)
# Definiujemy m[0] dla stanu początkowego, stąd zakres 0:K
@variable(model_zad3, m[0:K] >= 0)


# --- Funkcja celu ---
# Minimalizacja sumy kosztów produkcji (normalnej i ponadwym.) oraz magazynowania
@objective(model_zad3, Min, 
    sum( koszt_norm[j]*p[j] + koszt_ponad[j]*e[j] + koszt_magazyn*m[j] for j in Okresy )
)


# --- Ograniczenia ---
# 1. Bilans magazynu
# Magazyn[j] = Magazyn[j-1] + Produkcja_Łączna[j] - Popyt[j]
@constraint(model_zad3, BilansMagazynu[j in Okresy],
    m[j] == m[j-1] + p[j] + e[j] - popyt[j]
)

# 2. Stan początkowy magazynu (ustawiamy wartość dla m[0])
@constraint(model_zad3, PoczatekMagazynu, m[0] == magazyn_pocz)

# 3. Limity produkcji normalnej
@constraint(model_zad3, LimitProdNorm[j in Okresy], p[j] <= limit_prod_norm)

# 4. Limity produkcji ponadwymiarowej (zależne od okresu)
@constraint(model_zad3, LimitProdPonad[j in Okresy], e[j] <= limit_ponad[j])

# 5. Limity pojemności magazynu (na koniec każdego okresu 1..K)
@constraint(model_zad3, LimitMagazynu[j in Okresy], m[j] <= limit_magazyn)


# --- 5. Rozwiązanie modelu ---
println("Model zbudowany. Rozwiązuję...")
optimize!(model_zad3)


# --- 6. Prezentacja wyników ---
println("\n" * "="^40)
println("           WYNIKI ZADANIA 3")
println("="^40)

if termination_status(model_zad3) == MOI.OPTIMAL
    println("\n--- ZNALEZIONO ROZWIĄZANIE OPTYMALNE ---")
    
    println("\n(a) Jaki jest minimalny łączny koszt?")
    # Poprawiony printf bez apostrofu
    @printf("    Minimalny koszt: %d \$\n", round(Int, objective_value(model_zad3)))

    println("\n--- Szczegółowy plan produkcji i magazynowania ---")
    println("-------------------------------------------------------------------------")
    println("Okres | Popyt | Prod.Norm. | Prod.Ponad. | Prod.Łącznie | Magazyn (koniec)")
    println("-------------------------------------------------------------------------")
    
    # Drukujemy stan początkowy
    @printf("  0   |   -   |     -      |      -      |       -      |     %.0f\n", value(m[0]))
    
    # Drukujemy wyniki dla każdego okresu
    for j in Okresy
        @printf("  %d   | %5d |   %8.0f   |    %8.0f   |     %8.0f   |     %.0f\n",
                j,
                popyt[j],
                value(p[j]),
                value(e[j]),
                value(p[j]) + value(e[j]),
                value(m[j])
        )
    end
    println("-------------------------------------------------------------------------")


    println("\n(b) W których okresach zaplanowano produkcję ponadwymiarową?")
    produkcja_ponad = false # Flaga globalna
    for j in Okresy
        if value(e[j]) > 1e-6 # Sprawdzamy z tolerancją
            @printf("    Okres %d: %.0f jednostek\n", j, value(e[j]))
            global produkcja_ponad = true # POPRAWKA: modyfikujemy flagę globalną
        end
    end
    if !produkcja_ponad
        println("    W żadnym okresie.")
    end

    println("\n(c) W których okresach możliwości magazynowania są wyczerpane?")
    magazyn_pelny = false # Flaga globalna
    for j in Okresy
        if abs(value(m[j]) - limit_magazyn) < 1e-6 # Porównanie z tolerancją
            @printf("    Na koniec okresu %d (stan magazynu: %.0f)\n", j, value(m[j]))
            global magazyn_pelny = true # POPRAWKA: modyfikujemy flagę globalną
        end
    end
    if !magazyn_pelny
        println("    W żadnym okresie.")
    end

else
    println("\n!!! PROBLEM Z ROZWIĄZANIEM !!!")
    println("Status: ", termination_status(model_zad3))
end

println("="^40 * "\n")