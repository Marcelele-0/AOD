import os
import subprocess
import re
import csv

# Konfiguracja
ALGORITHMS = ["./dijkstra", "./dial", "./radixheap"]
INPUT_DIR = "test_files"
OUTPUT_CSV = "wyniki_czasow.csv"

# Regex do wyciągania czasu: "Sredni czas SS: 123.456 ms"
TIME_REGEX = re.compile(r"Sredni czas SS:\s+([\d\.]+)\s+ms")

def run_benchmark():
    # Otwieramy plik CSV do zapisu wyników
    with open(OUTPUT_CSV, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        # Nagłówki kolumn
        writer.writerow(["Rodzina", "Nazwa_Pliku", "Algorytm", "Liczba_Wierzcholkow", "Czas_ms"])

        print(f"Rozpoczynam testy w katalogu: {INPUT_DIR}...")
        
        # Spacer po katalogach (os.walk wchodzi w głąb folderów)
        for root, dirs, files in os.walk(INPUT_DIR):
            # Wyciągamy tylko pliki .gr i sortujemy je
            gr_files = sorted([f for f in files if f.endswith(".gr")])

            for gr_file in gr_files:
                base_name = os.path.splitext(gr_file)[0]
                gr_path = os.path.join(root, gr_file)
                ss_path = os.path.join(root, base_name + ".ss")
                
                # Sprawdzamy czy istnieje plik .ss (bez niego nie ma testu p2p/ss)
                if not os.path.exists(ss_path):
                    continue

                # Nazwa rodziny to nazwa folderu nadrzędnego (np. Random4-n)
                family = os.path.basename(root)
                print(f"--> Testowanie: {family} / {gr_file}")

                for algo in ALGORITHMS:

                    if "dial" in algo and "-C" in family:
                        print(f"    [{algo.replace('./', '')}] POMINIĘTO (Zbyt duze koszty C)")
                        continue
                        
                    # Komenda: ./dijkstra -d plik.gr -ss plik.ss -oss /dev/null
                    cmd = [algo, "-d", gr_path, "-ss", ss_path, "-oss", "/dev/null"]

                    try:
                        result = subprocess.run(cmd, capture_output=True, text=True)
                        output = result.stdout
                        
                        # Szukamy czasu w outputcie
                        match = TIME_REGEX.search(output)
                        if match:
                            time_ms = match.group(1)
                            
                            # Próba znalezienia liczby wierzchołków w outputcie
                            n_match = re.search(r"Wierzcholkow:\s+(\d+)", output)
                            n = n_match.group(1) if n_match else "0"

                            # Zapis do CSV i na ekran
                            writer.writerow([family, gr_file, algo.replace("./", ""), n, time_ms])
                            print(f"    [{algo.replace('./', '')}] {time_ms} ms")
                        else:
                            print(f"    [{algo}] Błąd lub brak wyniku czasu.")

                    except Exception as e:
                        print(f"    Błąd krytyczny: {e}")

    print(f"\n✅ Zakończono! Wyniki w pliku: {OUTPUT_CSV}")

if __name__ == "__main__":
    run_benchmark()