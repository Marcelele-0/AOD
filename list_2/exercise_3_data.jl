# Plik: exercise_3_data.jl
# Definicja danych dla Zadania 3

function pobierz_dane_zad3()
    # Zbiory
    Okresy = 1:4 # Używamy zakresu 1, 2, 3, 4
    K = 4

    # Parametry per okres (użyjemy Dict dla łatwego dostępu po indeksie)
    # cj - koszt normalny
    koszt_norm = Dict(1 => 6000, 2 => 4000, 3 => 8000, 4 => 9000)
    
    # aj - limit ponadwymiarowy
    limit_ponad = Dict(1 => 60, 2 => 65, 3 => 70, 4 => 60)
    
    # oj - koszt ponadwymiarowy
    koszt_ponad = Dict(1 => 8000, 2 => 6000, 3 => 10000, 4 => 11000)
    
    # dj - popyt
    popyt = Dict(1 => 130, 2 => 80, 3 => 125, 4 => 195)

    # Parametry globalne
    limit_prod_norm = 100
    limit_magazyn = 70
    koszt_magazyn = 1500 # Koszt przechowania 1 jednostki przez 1 okres
    magazyn_pocz = 15
    
    return (Okresy, K, koszt_norm, limit_ponad, koszt_ponad, popyt, 
            limit_prod_norm, limit_magazyn, koszt_magazyn, magazyn_pocz)
end