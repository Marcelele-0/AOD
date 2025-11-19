# Plik: exercise_5_data.jl
# Definicja danych dla Zadania 5 (Policja)

function pobierz_dane_zad5()
    # Zbiory
    Dzielnice = ["p1", "p2", "p3"]
    Zmiany = [1, 2, 3]

    # Parametry (wiersze = dzielnice, kolumny = zmiany 1, 2, 3)
    
    # Minimalna liczba radiowozów w komórce (Tabela 1)
    # p1: [2, 4, 3], p2: [3, 6, 5], p3: [5, 7, 6]
    min_komorka = [
        2 4 3;
        3 6 5;
        5 7 6
    ]

    # Maksymalna liczba radiowozów w komórce (Tabela 2)
    # p1: [3, 7, 5], p2: [5, 7, 10], p3: [8, 12, 10]
    max_komorka = [
        3 7 5;
        5 7 10;
        8 12 10
    ]

    # Wymagania globalne dla Zmian (kolumn): >= 10, 20, 18
    min_zmiana = [10, 20, 18]

    # Wymagania globalne dla Dzielnic (wierszy): >= 10, 14, 13
    min_dzielnica = [10, 14, 13]

    return (Dzielnice, Zmiany, min_komorka, max_komorka, min_zmiana, min_dzielnica)
end