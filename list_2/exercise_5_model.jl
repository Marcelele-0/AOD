# Autor: Marcel Musiałek
#
# Plik: exercise_5_model.jl
# Rozwiązanie Zadania 5 z listy 2 (AOD) - Policja

# --- 1. Aktywacja środowiska projektu ---
import Pkg
Pkg.activate(@__DIR__) 

# --- 2. Automatyczna instalacja pakietów ---
required_packages = ["JuMP", "GLPK"] 
for pkg_name in required_packages
    if isnothing(Base.find_package(pkg_name))
        Pkg.add(pkg_name)
    end
end

using JuMP
using GLPK
using Printf

include("exercise_5_data.jl")

# Pobranie danych
(Dzielnice, Zmiany, min_komorka, max_komorka, min_zmiana, min_dzielnica) = pobierz_dane_zad5()
n_dzielnic = length(Dzielnice)
n_zmian = length(Zmiany)

println("Dane wczytane. Budowa modelu...")

# --- Budowa modelu ---
model_zad5 = Model(GLPK.Optimizer)

# Zmienne decyzyjne: x[d, z] - liczba radiowozów w dzielnicy d na zmianie z
# Muszą być całkowitoliczbowe (Int) i nieujemne
@variable(model_zad5, x[1:n_dzielnic, 1:n_zmian] >= 0, Int)

# Funkcja celu: Minimalizacja całkowitej liczby radiowozów
@objective(model_zad5, Min, sum(x))

# --- Ograniczenia ---

# 1. Ograniczenia lokalne (dla każdej komórki min i max z tabel)
for d in 1:n_dzielnic
    for z in 1:n_zmian
        @constraint(model_zad5, x[d, z] >= min_komorka[d, z])
        @constraint(model_zad5, x[d, z] <= max_komorka[d, z])
    end
end

# 2. Ograniczenia sumaryczne dla Zmian (kolumn)
for z in 1:n_zmian
    @constraint(model_zad5, sum(x[:, z]) >= min_zmiana[z])
end

# 3. Ograniczenia sumaryczne dla Dzielnic (wierszy)
for d in 1:n_dzielnic
    @constraint(model_zad5, sum(x[d, :]) >= min_dzielnica[d])
end


# --- Rozwiązanie ---
println("Rozwiązuję...")
optimize!(model_zad5)


# --- Wyniki ---
println("\n" * "="^40)
println("           WYNIKI ZADANIA 5")
println("="^40)

if termination_status(model_zad5) == MOI.OPTIMAL
    total_cars = round(Int, objective_value(model_zad5))
    println("\n--- ZNALEZIONO ROZWIĄZANIE OPTYMALNE ---")
    println("Całkowita liczba radiowozów: $total_cars")

    println("\nOptymalny przydział (Macierz Dzielnice x Zmiany):")
    println("      | Zmiana 1 | Zmiana 2 | Zmiana 3 |  SUMA")
    println("--------------------------------------------------")
    
    for d in 1:n_dzielnic
        # Obliczamy sumę wiersza dla wyświetlania
        row_sum = sum(round(Int, value(x[d, z])) for z in 1:n_zmian)
        
        @printf("  %s  |", Dzielnice[d])
        for z in 1:n_zmian
            val = round(Int, value(x[d, z]))
            @printf("    %2d    |", val)
        end
        @printf("   %2d  (Wymagane: %d)\n", row_sum, min_dzielnica[d])
    end
    println("--------------------------------------------------")
    print(" SUMA |")
    for z in 1:n_zmian
        col_sum = sum(round(Int, value(x[d, z])) for d in 1:n_dzielnic)
        @printf("    %2d    |", col_sum)
    end
    # Tutaj była poprawka:
    @printf("\nWymag:|    %2d    |    %2d    |    %2d    |\n", min_zmiana[1], min_zmiana[2], min_zmiana[3])

else
    println("!!! PROBLEM Z ROZWIĄZANIEM: ", termination_status(model_zad5))
end
println("="^40 * "\n")