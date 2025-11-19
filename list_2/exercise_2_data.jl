# Plik: exercise_2_data.jl
# Definicja danych dla Zadania 2

function pobierz_dane_zad2()
    # Zbiory
    Wyroby = ["P1", "P2", "P3", "P4"]
    Maszyny = ["M1", "M2", "M3"]

    # --- Parametry ---

    # Czas obróbki [minuty / kg]
    # czas[w, m] - czas dla wyrobu 'w' na maszynie 'm'
    czas = Dict(
        ("P1", "M1") => 5,  ("P1", "M2") => 10, ("P1", "M3") => 6,
        ("P2", "M1") => 3,  ("P2", "M2") => 6,  ("P2", "M3") => 4,
        ("P3", "M1") => 4,  ("P3", "M2") => 5,  ("P3", "M3") => 3,
        ("P4", "M1") => 4,  ("P4", "M2") => 2,  ("P4", "M3") => 1
    )

    # Dostępny czas maszyn [minuty na tydzień]
    # (60 godzin * 60 minut/godzina)
    dostepnosc_maszyn = Dict(
        "M1" => 60 * 60,
        "M2" => 60 * 60,
        "M3" => 60 * 60
    )

    # Ceny sprzedaży [$ / kg]
    cena_sprzedazy = Dict(
        "P1" => 9, "P2" => 7, "P3" => 6, "P4" => 5
    )

    # Koszty materiałowe [$ / kg]
    koszt_materialu = Dict(
        "P1" => 4, "P2" => 1, "P3" => 1, "P4" => 1
    )

    # Koszty pracy maszyn [$ / godzina]
    koszt_maszyny_h = Dict(
        "M1" => 2, "M2" => 2, "M3" => 3
    )
    
    # Przeliczenie kosztu maszyn na [$ / minuta] dla spójności jednostek
    koszt_maszyny_min = Dict(
        m => koszt_maszyny_h[m] / 60.0 for m in Maszyny
    )

    # Maksymalny tygodniowy popyt [kg]
    popyt = Dict(
        "P1" => 400, "P2" => 100, "P3" => 150, "P4" => 500
    )

    # --- Obliczenie ZYSKU JEDNOSTKOWEGO ---
    # Zysk = Cena - Koszt_Materiału - Koszt_Pracy_Maszyn
    # Koszt_Pracy_Maszyn = Suma( (czas[w,m] * koszt_maszyny_min[m]) dla wszystkich maszyn m)
    
    zysk_jednostkowy = Dict{String, Float64}()
    for w in Wyroby
        koszt_operacyjny_maszyn = sum( czas[w, m] * koszt_maszyny_min[m] for m in Maszyny )
        zysk_jednostkowy[w] = cena_sprzedazy[w] - koszt_materialu[w] - koszt_operacyjny_maszyn
    end

    # Zwracamy wszystkie potrzebne dane
    return (Wyroby, Maszyny, czas, dostepnosc_maszyn, popyt, zysk_jednostkowy)
end