import pandas as pd
import matplotlib.pyplot as plt
import os
import sys
import re

# Sprawdzenie bibliotek
try:
    import pandas
    import matplotlib
except ImportError:
    print("Brakuje bibliotek! Zainstaluj: sudo pacman -S python-pandas python-matplotlib")
    sys.exit(1)

plik_csv = 'wyniki_czasow.csv'
if not os.path.exists(plik_csv):
    print(f"Błąd: Nie znaleziono {plik_csv}")
    sys.exit(1)

# Wczytanie danych
df = pd.read_csv(plik_csv)
df['Liczba_Wierzcholkow'] = pd.to_numeric(df['Liczba_Wierzcholkow'])
df['Czas_ms'] = pd.to_numeric(df['Czas_ms'])

# Funkcja do wyciągania parametru z nazwy pliku
def extract_param(filename):
    match = re.search(r'\.(\d+)\.', filename)
    return int(match.group(1)) if match else 0

df['Parametr_Pliku'] = df['Nazwa_Pliku'].apply(extract_param)

if not os.path.exists('wykresy'):
    os.makedirs('wykresy')

rodziny = df['Rodzina'].unique()
print("Generowanie ostatecznych wykresów...")

for rodzina in rodziny:
    plt.figure(figsize=(10, 6))
    data_rodzina = df[df['Rodzina'] == rodzina]

    # --- LOGIKA SPECJALNA DLA USA-ROAD (Słupki) ---
    if "USA-road" in rodzina:
        # Sortujemy od najszybszego do najwolniejszego
        subset = data_rodzina.sort_values('Czas_ms')
        
        # Rysujemy słupki
        bars = plt.bar(subset['Algorytm'], subset['Czas_ms'], color=['#1f77b4', '#ff7f0e', '#2ca02c'])
        
        plt.title(f'Porównanie algorytmów na mapie NY - {rodzina}')
        plt.ylabel('Średni czas (ms)')
        plt.xlabel('Algorytm')
        plt.grid(axis='y', linestyle='--', alpha=0.7)
        
        # Dodajemy wartości nad słupkami, żeby było widać dokładny czas
        for bar in bars:
            height = bar.get_height()
            plt.text(bar.get_x() + bar.get_width()/2., 1.01*height,
                     f'{height:.2f} ms',
                     ha='center', va='bottom')

    # --- LOGIKA DLA RODZIN "C" (Zmienne koszty) ---
    elif "-C" in rodzina:
        for algo in data_rodzina['Algorytm'].unique():
            subset = data_rodzina[data_rodzina['Algorytm'] == algo].sort_values('Parametr_Pliku')
            if not subset.empty:
                plt.plot(subset['Parametr_Pliku'], subset['Czas_ms'], marker='o', label=algo, linewidth=2)
        
        plt.title(f'Czas działania - {rodzina} (Zmienne koszty krawędzi)')
        plt.xlabel('Parametr instancji (log C)')
        plt.ylabel('Średni czas (ms) [skala log]')
        plt.yscale('log')
        plt.legend()
        plt.grid(True, which="both", ls="-", alpha=0.5)

    # --- LOGIKA STANDARDOWA (Zmienne N) ---
    else:
        for algo in data_rodzina['Algorytm'].unique():
            subset = data_rodzina[data_rodzina['Algorytm'] == algo].sort_values('Liczba_Wierzcholkow')
            if not subset.empty:
                plt.plot(subset['Liczba_Wierzcholkow'], subset['Czas_ms'], marker='o', label=algo, linewidth=2)
        
        plt.title(f'Czas działania - {rodzina} (Zmienna wielkość grafu)')
        plt.xlabel('Liczba wierzchołków (n)')
        plt.ylabel('Średni czas (ms) [skala log]')
        plt.xscale('log')
        plt.yscale('log')
        plt.legend()
        plt.grid(True, which="both", ls="-", alpha=0.5)

    nazwa_pliku = f"wykresy/{rodzina}.png"
    plt.savefig(nazwa_pliku)
    print(f" -> Zapisano: {nazwa_pliku}")
    plt.close()

print("\nGotowe! Folder 'wykresy' zawiera teraz poprawne pliki.")