# Plik: exercise_4_data.jl
# Definicja danych dla Zadania 4(a) i 4(b)

# --- Dane dla 4(a) (z treści zadania) ---
function pobierz_dane_zad4a()
    Nodes = 1:10
    StartNode = 1
    EndNode = 10
    MaxTime = 15

    Arcs = Tuple{Int, Int}[
        (1, 2), (1, 3), (1, 4), (1, 5),
        (2, 3),
        (3, 4), (3, 5), (3, 10),
        (4, 5), (4, 7),
        (5, 6), (5, 7), (5, 10),
        (6, 1), (6, 7), (6, 10),
        (7, 3), (7, 8), (7, 9),
        (8, 9),
        (9, 10)
    ]

    Costs = Dict{Tuple{Int, Int}, Int}(
        (1, 2) => 3, (1, 3) => 4, (1, 4) => 7, (1, 5) => 8,
        (2, 3) => 2,
        (3, 4) => 4, (3, 5) => 2, (3, 10) => 6,
        (4, 5) => 1, (4, 7) => 3,
        (5, 6) => 5, (5, 7) => 3, (5, 10) => 5,
        (6, 1) => 5, (6, 7) => 2, (6, 10) => 7,
        (7, 3) => 4, (7, 8) => 3, (7, 9) => 1,
        (8, 9) => 1,
        (9, 10) => 2
    )

    Times = Dict{Tuple{Int, Int}, Int}(
        (1, 2) => 4, (1, 3) => 9, (1, 4) => 10, (1, 5) => 12,
        (2, 3) => 3,
        (3, 4) => 6, (3, 5) => 2, (3, 10) => 11,
        (4, 5) => 1, (4, 7) => 5,
        (5, 6) => 6, (5, 7) => 3, (5, 10) => 8,
        (6, 1) => 8, (6, 7) => 2, (6, 10) => 11,
        (7, 3) => 6, (7, 8) => 5, (7, 9) => 1,
        (8, 9) => 2,
        (9, 10) => 2
    )
    
    # Zwracamy krotkę z danymi
    return (Nodes, Arcs, Costs, Times, StartNode, EndNode, MaxTime)
end


# --- Dane dla 4(b) (własny egzemplarz) ---
function pobierz_dane_zad4b()
    Nodes = 1:10
    StartNode = 1
    EndNode = 10
    MaxTime = 15 # Najtańsza ścieżka (czas=20) jest za długa

    Arcs = Tuple{Int, Int}[
        # Ścieżka 1: 2 krawędzie, KOSZT=2, CZAS=20 (za długa)
        (1, 5), (5, 10),
        
        # Ścieżka 2: 3 krawędzie, KOSZT=6, CZAS=12 (optymalna)
        (1, 2), (2, 6), (6, 10),
        
        # Ścieżka 3: 3 krawędzie, KOSZT=30, CZAS=3 (bardzo droga)
        (1, 3), (3, 7), (7, 10)
    ]

    Costs = Dict{Tuple{Int, Int}, Int}(
        (1, 5) => 1, (5, 10) => 1,
        (1, 2) => 2, (2, 6) => 2, (6, 10) => 2,
        (1, 3) => 10, (3, 7) => 10, (7, 10) => 10
    )

    Times = Dict{Tuple{Int, Int}, Int}(
        (1, 5) => 10, (5, 10) => 10,
        (1, 2) => 4, (2, 6) => 4, (6, 10) => 4,
        (1, 3) => 1, (3, 7) => 1, (7, 10) => 1
    )
    
    return (Nodes, Arcs, Costs, Times, StartNode, EndNode, MaxTime)
end