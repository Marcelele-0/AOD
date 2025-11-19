# Autor: Marcel Musiałek
#
# Plik: exercise_2_model.jl
# Rozwiązanie Zadania 2 z listy 2 (AOD)

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
using Printf # Do ładnego formatowania liczb

# Dołączenie pliku z danymi
include("exercise_2_data.jl")

# Pobranie danych
(Wyroby, Maszyny, czas, dostepnosc_maszyn, popyt, zysk_jednostkowy) = pobierz_dane_zad2()

println("Dane wczytane. Zysk jednostkowy (po odjęciu kosztów maszyn):")
for w in Wyroby
    @printf("   %s: %.4f \$\n", w, zysk_jednostkowy[w])
end
println("Rozpoczynam budowę modelu...")


# --- 4. Budowa modelu ---
model_zad2 = Model(GLPK.Optimizer)

# --- Zmienne decyzyjne ---
# x[w] - ile kilogramów [kg] wyrobu 'w' wyprodukować w tygodniu
# Ograniczone z dołu przez 0, a z góry przez maksymalny popyt
@variable(model_zad2, 0 <= x[w in Wyroby] <= popyt[w])

# --- Funkcja celu ---
# Maksymalizacja całkowitego zysku tygodniowego
# Zysk = Suma( zysk_jednostkowy[w] * ilość[w] )
@objective(model_zad2, Max, 
    sum( zysk_jednostkowy[w] * x[w] for w in Wyroby )
)

# --- Ograniczenia ---
# 1. Ograniczenie dostępności maszyn
# Dla każdej maszyny 'm', łączny czas pracy poświęcony na wszystkie wyroby
# nie może przekroczyć jej dostępności.
# Czas_na_maszynie_m = Suma( czas_na_kg[w,m] * ilosc_kg[w] )
@constraint(model_zad2, OgrCzasuMaszyn[m in Maszyny],
    sum( czas[w, m] * x[w] for w in Wyroby ) <= dostepnosc_maszyn[m]
)

# Uwaga: Ograniczenie popytu jest już zawarte w definicji zmiennej!
# @variable(..., <= popyt[w])


# --- 5. Rozwiązanie modelu ---
println("Model zbudowany. Rozwiązuję...")
optimize!(model_zad2)


# --- 6. Prezentacja wyników ---
println("\n" * "="^40)
println("           WYNIKI ZADANIA 2")
println("="^40)

if termination_status(model_zad2) == MOI.OPTIMAL
    println("\n--- ZNALEZIONO ROZWIĄZANIE OPTYMALNE ---")
    
    println("\nOptymalny tygodniowy plan produkcji:")
    println("----------------------------------------")
    println("Wyrób | Ilość produkcji [kg] | Popyt max.")
    println("----------------------------------------")
    
    total_prod = 0.0
    for w in Wyroby
        prod = value(x[w])
        @printf("  %s  |     %14.2f   |   %7.0f\n",
                w,
                prod,
                popyt[w]
        )
        global total_prod += prod
    end
    println("----------------------------------------")
    @printf(" RAZEM |     %14.2f   |\n", total_prod)


    println("\nWykorzystanie maszyn (w minutach):")
    for m in Maszyny
        used_time = sum(czas[w, m] * value(x[w]) for w in Wyroby)
        max_time = dostepnosc_maszyn[m]
        percent_used = (used_time / max_time) * 100
        @printf("   %s: %.0f / %.0f minut  (%.2f %%)\n",
                m, used_time, max_time, percent_used
        )
    end
    
    println("\nObliczony optymalny zysk tygodniowy:")
    @printf("    ZYSK: %.2f \$\n", objective_value(model_zad2))

else
    println("\n!!! PROBLEM Z ROZWIĄZANIEM !!!")
    println("Status: ", termination_status(model_zad2))
end

println("="^40 * "\n")