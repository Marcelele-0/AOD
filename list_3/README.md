# Porównanie implementacji algorytmu Dijkstry

Projekt zawiera implementację trzech wariantów algorytmu najkrótszej ścieżki:
1. Standardowy Dijkstra (std::priority_queue)
2. Algorytm Diala (Kubełkowy)
3. Radix Heap Dijkstra

## Wymagania
* System: Linux (testowano na CachyOS)
* Kompilator: g++ (obsługujący C++17)
* Narzędzie: make

## Kompilacja
Aby skompilować wszystkie wersje programów, wpisz:

```bash
make
```

Spowoduje to powstanie plików wykonywalnych: dijkstra, dial, radixheap.
Uruchamianie

Programy przyjmują parametry zgodne ze specyfikacją zadania DIMACS.

Przykłady:

```bash
./dijkstra -d inputs/USA-road-d.NY.gr -ss inputs/test.ss -oss wyniki.ss.res
./dial -d inputs/USA-road-d.NY.gr -p2p inputs/test.p2p -op2p wyniki.p2p.res
```