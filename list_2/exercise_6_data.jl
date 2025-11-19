# Plik: exercise_6_data.jl
# Definicja danych dla Zadania 6 (Kamery i Kontenery)

function pobierz_dane_zad6()
    # Wymiary terenu (m x n) - zgodnie z poleceniem >= 5
    m = 6 # wiersze
    n = 6 # kolumny
    
    # Lista pozycji kontenerów (wiersz, kolumna)
    # Rozmieszczone tak, aby wymagały kilku kamer
    kontenery = Tuple{Int, Int}[
        (1, 1),
        (2, 5),
        (3, 3),
        (4, 6),
        (5, 2),
        (6, 4)
    ]
    
    # Wartości parametru k do przetestowania
    # k = zasięg widzenia (kratek w każdą stronę: góra, dół, lewo, prawo)
    # Sprawdzimy krótki zasięg (1) i średni zasięg (2)
    lista_k = [1, 2]

    return (m, n, kontenery, lista_k)
end