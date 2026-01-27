# ============================================================================
#  Makefile (Poprawiony dla Arch Linux / GCC 14)
# ============================================================================

CC       = gcc
# Dodano flagi ignorujące błędy starego C
CFLAGS   = -O3 -DNDEBUG -DPERMUTE_NODES  -I ../../lib -I ../../lib/ll-core/include \
           -Wno-error -Wno-implicit-function-declaration -Wno-return-type -Wno-int-conversion

LDFLAGS  = 
LOADLIBS = -lm        

LIB      = ../../lib/

all: tor.exe

tor.exe: tor.c $(LIB)random.c $(LIB)permute.c
	# ZMIANA: $(LOADLIBS) przesunięte na koniec
	$(CC) $(CFLAGS) -o tor.exe tor.c -I$(LIB) ../../lib/ll-core/src/*.c $(LOADLIBS)

clean:
	rm -f *~ tor.exe