import sys
import random
import os

def parse_header(gr_file):
    """Odczytuje liczbę wierzchołków (n) z nagłówka pliku .gr"""
    with open(gr_file, 'r') as f:
        for line in f:
            if line.startswith('p'):
                parts = line.split()
                # format linii: p sp n m
                # np.: p sp 1024 4096
                return int(parts[2])
    return 0

def gen_ss(n, output_file):
    """Generuje plik .ss (źródła)"""
    # Wymagania: 
    # 1. Źródło o najmniejszym indeksie (zwykle 1)
    # 2. Pięć wierzchołków losowych
    sources = {1} 
    while len(sources) < 6: # 1 + 5 = 6 źródeł
        sources.add(random.randint(1, n))
    
    with open(output_file, 'w') as f:
        f.write("c Plik zrodla wygenerowany automatycznie\n")
        f.write(f"p aux sp ss {len(sources)}\n")
        for s in sorted(list(sources)):
            f.write(f"s {s}\n")
    print(f"   -> Utworzono: {output_file}")

def gen_p2p(n, output_file):
    """Generuje plik .p2p (pary wierzchołków)"""
    # Wymagania:
    # 1. Para (min, max), czyli (1, n)
    # 2. 4 inne losowe pary
    pairs = set()
    pairs.add((1, n))
    
    while len(pairs) < 5: # 1 + 4 = 5 par
        u = random.randint(1, n)
        v = random.randint(1, n)
        if u != v:
            pairs.add((u, v))
            
    with open(output_file, 'w') as f:
        f.write("c Plik p2p wygenerowany automatycznie\n")
        f.write(f"p aux sp p2p {len(pairs)}\n")
        for u, v in pairs:
            f.write(f"q {u} {v}\n")
    print(f"   -> Utworzono: {output_file}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Użycie: python generate_tests.py <ścieżka_do_pliku.gr>")
        sys.exit(1)

    gr_path = sys.argv[1]
    
    # Ustalanie nazw plików wyjściowych (zamiana .gr na .ss i .p2p)
    base_name = os.path.splitext(gr_path)[0]
    ss_path = base_name + ".ss"
    p2p_path = base_name + ".p2p"
    
    try:
        n = parse_header(gr_path)
        if n == 0:
            print(f"Błąd: Nie znaleziono nagłówka 'p sp n m' w pliku {gr_path}")
            sys.exit(1)
            
        print(f"Przetwarzanie: {gr_path} (n={n})")
        gen_ss(n, ss_path)
        gen_p2p(n, p2p_path)
        
    except Exception as e:
        print(f"Błąd krytyczny: {e}")