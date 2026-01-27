========================================================================
ALGORYTMY OPTYMALIZACJI DYSKRETNEJ - LABORATORIUM 3
Porównanie implementacji algorytmu Dijkstry
========================================================================

AUTOR:
------------------------------------------------------------------------
Imię i nazwisko: [TUTAJ WPISZ SWOJE IMIĘ I NAZWISKO]
Numer indeksu:   [TUTAJ WPISZ SWÓJ NUMER INDEKSU]
Data:            Styczeń 2026

OPIS ZAWARTOŚCI PROJEKTU:
------------------------------------------------------------------------
Katalog zawiera implementację trzech wariantów algorytmu wyznaczania
najkrótszych ścieżek w grafie (Dijkstra, Dial, Radix Heap) oraz skrypty
pomocnicze do przeprowadzania testów.

Struktura plików:
.
├── src/                - Kod źródłowy w języku C++
│   ├── main.cpp        - Główny plik obsługujący argumenty i wywołania
│   ├── graph.hpp       - Struktura grafu i wczytywanie danych (DIMACS)
│   ├── utils.hpp       - Funkcje pomocnicze (pomiar czasu, zapis)
│   └── algos/          - Implementacje algorytmów
│       ├── dijkstra.hpp    - Klasyczny algorytm Dijkstry (std::priority_queue)
│       ├── dial.hpp        - Algorytm Diala (implementacja kubełkowa)
│       └── radix.hpp       - Algorytm Radix Heap
├── Makefile            - Plik budowania projektu
├── generate_tests.py   - Skrypt generujący pliki zapytań (.ss i .p2p)
├── run_experiments.py  - Skrypt automatyzujący testy i generujący CSV
└── README.txt          - Ten plik

WYMAGANIA SYSTEMOWE I BIBLIOTEKI:
------------------------------------------------------------------------
1. System operacyjny: Linux (testowano na Arch Linux / Ubuntu).
2. Kompilator: g++ wspierający standard C++17.
3. Narzędzia: make.
4. Język Python 3 (do uruchomienia skryptów testowych).

Wymagane biblioteki:
- Program korzysta wyłącznie ze standardowej biblioteki C++ (STL).
  Nie jest wymagane instalowanie dodatkowych zewnętrznych bibliotek C++.
- Do skryptów Pythona wymagane są standardowe moduły: os, sys, subprocess,
  random, re, csv.

KOMPILACJA:
------------------------------------------------------------------------
Aby skompilować projekt, należy w głównym katalogu uruchomić polecenie:

    make

W wyniku kompilacji powstaną trzy pliki wykonywalne:
1. ./dijkstra   - Wariant podstawowy (Kopiec binarny)
2. ./dial       - Algorytm Diala
3. ./radixheap  - Algorytm Radix Heap

Aby wyczyścić pliki obiektowe i binarki:

    make clean

URUCHAMIANIE PROGRAMÓW:
------------------------------------------------------------------------
Programy obsługują format wywołania zgodny ze specyfikacją zadania.

1. Badanie czasu (tryb Single Source - ss):
   Wyznacza najkrótsze ścieżki od źródeł podanych w pliku .ss do wszystkich
   innych wierzchołków.

   Składnia:
   ./[program] -d [plik_grafu.gr] -ss [zrodla.ss] -oss [wynik.res]

   Przykłady:
   ./dijkstra -d inputs/graf.gr -ss inputs/graf.ss -oss wynik_dijkstra.res
   ./dial -d inputs/graf.gr -ss inputs/graf.ss -oss wynik_dial.res
   ./radixheap -d inputs/graf.gr -ss inputs/graf.ss -oss wynik_radix.res

2. Wyznaczanie odległości dla par (tryb Point-to-Point - p2p):
   Wyznacza długość ścieżki pomiędzy parami wierzchołków z pliku .p2p.

   Składnia:
   ./[program] -d [plik_grafu.gr] -p2p [pary.p2p] -op2p [wynik.res]

   Przykłady:
   ./dijkstra -d inputs/graf.gr -p2p inputs/graf.p2p -op2p wynik.p2p.res

FORMAT DANYCH WEJŚCIOWYCH:
------------------------------------------------------------------------
Programy obsługują formaty zdefiniowane przez 9th DIMACS Implementation Challenge:
- .gr : Definicja grafu (wierzchołki i łuki z wagami).
- .ss : Lista wierzchołków źródłowych (p aux sp ss <liczba>).
- .p2p: Lista par wierzchołków (q <start> <koniec>).

AUTOMATYZACJA TESTÓW:
------------------------------------------------------------------------
W katalogu znajdują się skrypty ułatwiające pracę z danymi testowymi:

1. generate_tests.py:
   Generuje pliki .ss (5 losowych źródeł + min index) oraz .p2p (pary)
   dla wskazanego pliku grafu.
   Użycie: python3 generate_tests.py <plik.gr>

2. run_experiments.py:
   Przeszukuje katalog 'test_files', uruchamia wszystkie trzy algorytmy
   dla znalezionych grafów i generuje zbiorczy plik 'wyniki_czasow.csv'
   gotowy do analizy i tworzenia wykresów.
   Użycie: python3 run_experiments.py

UWAGI DO IMPLEMENTACJI:
------------------------------------------------------------------------
- Algorytm Radix Heap jest zoptymalizowany dla wag całkowitych. W przypadku
  grafów o bardzo dużej średnicy (rodzina Long-n) i ogromnych skumulowanych
  wagach, implementacja może napotkać ograniczenia zakresu (Segmentation Fault),
  co zostało odnotowane w sprawozdaniu.
- Algorytm Diala ma złożoność zależną od maksymalnej wagi krawędzi (C),
  dlatego dla dużych wag działa wolniej lub zużywa więcej pamięci.