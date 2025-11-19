# Autor: Marcel Musiałek
#
# Plik: exercise_1_model.jl
# Rozwiązanie Zadania 1 z listy 2 (AOD)


# --- 1. Aktywacja środowiska projektu ---
# (Uruchomi środowisko z folderu, w którym jest ten plik)
import Pkg
Pkg.activate(@__DIR__) 

# --- 2. Automatyczna instalacja pakietów ---
# (Doda pakiety do Project.toml, jeśli ich tam nie ma)
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

# Dołączenie pliku z danymi (musi być w tym samym folderze)
include("exercise_1_data.jl")

# Wywołanie funkcji z tamtego pliku, aby pobrać dane
Dostawcy, Lotniska, podaz, popyt, koszty = pobierz_dane_zad1()

println("Dane wczytane. Rozpoczynam budowę modelu...")


# --- 4. Budowa modelu ---

# Stworzenie pustego modelu
model_zad1 = Model(GLPK.Optimizer)

# Definicja zmiennych decyzyjnych
# x[d, l] - ile galonów paliwa dostarczy dostawca 'd' na lotnisko 'l'
@variable(model_zad1, x[d in Dostawcy, l in Lotniska] >= 0)

# Definicja funkcji celu
# Minimalizujemy całkowity koszt dostaw
@objective(model_zad1, Min, 
    sum( koszty[d, l] * x[d, l] for d in Dostawcy, l in Lotniska )
)

# Definicja ograniczeń
# Ograniczenie (A): Popyt na lotniskach musi zostać zaspokojony
# Suma dostaw od WSZYSTKICH dostawców na dane lotnisko 'l' musi 
# być RÓWNA zapotrzebowaniu tego lotniska.
@constraint(model_zad1, OgrPopyt[l in Lotniska],
    sum( x[d, l] for d in Dostawcy ) == popyt[l]
)

# Ograniczenie (B): Podaż dostawców nie może być przekroczona
# Suma dostaw od danego dostawcy 'd' do WSZYSTKICH lotnisk musi
# być MNIEJSZA LUB RÓWNA jego maksymalnym możliwościom.
@constraint(model_zad1, OgrPodaz[d in Dostawcy],
    sum( x[d, l] for l in Lotniska ) <= podaz[d]
)


# --- 5. Rozwiązanie modelu ---
println("Model zbudowany. Rozwiązuję...")
optimize!(model_zad1)


# --- 6. Prezentacja wyników ---
println("\n" * "="^40)
println("           WYNIKI ZADANIA 1")
println("="^40)

if termination_status(model_zad1) == MOI.OPTIMAL
    println("\n--- ZNALEZIONO ROZWIĄZANIE OPTYMALNE ---")
    
    println("\n(a) Jaki jest minimalny łączny koszt dostaw?")
    println("    Minimalny koszt: ", round(Int, objective_value(model_zad1)), " \$")

    println("\nOptymalny plan dostaw (w galonach):")
    for d in Dostawcy
        for l in Lotniska
            ilosc = value(x[d, l])
            if ilosc > 1e-6 # Drukujemy tylko niezerowe przepływy (z małą tolerancją)
                println("    $d -> $l: \t $(round(Int, ilosc)) galonów")
            end
        end
    end

    println("\n(b) Czy wszystkie firmy dostarczają paliwo?")
    uzycie_dostawcow = []
    for d in Dostawcy
        laczna_dostawa = sum(value(x[d, l]) for l in Lotniska)
        if laczna_dostawa > 1e-6
            push!(uzycie_dostawcow, d)
        end
    end
    
    if length(uzycie_dostawcow) == length(Dostawcy)
        println("    TAK, wszystkie firmy dostarczają paliwo.")
    else
        println("    NIE, tylko firmy: ", join(uzycie_dostawcow, ", "))
    end
    
    println("\n(c) Czy możliwości dostaw firm są wyczerpane?")
    # Sprawdzamy sumę dostaw w stosunku do podaży
    for d in Dostawcy
        laczna_dostawa = sum(value(x[d, l]) for l in Lotniska)
        procent_wykorzystania = (laczna_dostawa / podaz[d]) * 100
        
        print("    Firma $d: ")
        if abs(laczna_dostawa - podaz[d]) < 1e-6 # Porównanie z tolerancją
            println("TAK, wyczerpano limit (100%).")
        else
            println("NIE (dostarcza $(round(Int, laczna_dostawa)) z $(podaz[d]) galonów, ",
                    "co stanowi $(round(procent_wykorzystania, digits=2))%).")
        end
    end
    println("\nCałkowita dostarczona ilość paliwa:")
    println("    ", round(Int, sum(value(x[d, l]) for d in Dostawcy, l in Lotniska)), " galonów.")
    
    println("\nCałkowite zapotrzebowanie lotnisk:")
    println("    ", sum(popyt[l] for l in Lotniska), " galonów.")

else
    println("\n!!! PROBLEM Z ROZWIĄZANIEM !!!")
    println("Status: ", termination_status(model_zad1))
end

println("="^40)
println("         KONIEC PROGRAMU")
println("="^40 * "\n")