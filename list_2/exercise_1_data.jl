# Autor: Marcel Musiałek
#
# Plik: exercise_1_data.jl
# Rozwiązanie Zadania 1 z listy 2 (AOD)

function pobierz_dane_zad1()
    # Zbiory
    Dostawcy = ["Firma1", "Firma2", "Firma3"]
    Lotniska = ["Lotnisko1", "Lotnisko2", "Lotnisko3", "Lotnisko4"]

    # Parametry
    # Podaż (ile maksymalnie może dostarczyć firma)
    podaz = Dict(
        "Firma1" => 275000,
        "Firma2" => 550000,
        "Firma3" => 660000
    )

    # Popyt (ile potrzebuje lotnisko)
    popyt = Dict(
        "Lotnisko1" => 110000,
        "Lotnisko2" => 220000,
        "Lotnisko3" => 330000,
        "Lotnisko4" => 440000
    )

    # Koszty jednostkowe C[d, l]
    # Używamy Dict z krotkami (Dostawca, Lotnisko) jako kluczem
    # UWAGA: W treści zadania jest "Firma 1", "Firma 2", "Firma 2" - zakładam, że to błąd 
    # i ostatnia kolumna to "Firma 3"
    koszty = Dict(
        ("Firma1", "Lotnisko1") => 10, ("Firma2", "Lotnisko1") => 7,  ("Firma3", "Lotnisko1") => 8,
        ("Firma1", "Lotnisko2") => 10, ("Firma2", "Lotnisko2") => 11, ("Firma3", "Lotnisko2") => 14,
        ("Firma1", "Lotnisko3") => 9,  ("Firma2", "Lotnisko3") => 12, ("Firma3", "Lotnisko3") => 4,
        ("Firma1", "Lotnisko4") => 11, ("Firma2", "Lotnisko4") => 13, ("Firma3", "Lotnisko4") => 9
    )
    
    # Zwracamy wszystko w jednej ustrukturyzowanej formie
    return (Dostawcy, Lotniska, podaz, popyt, koszty)
end