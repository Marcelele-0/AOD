# ============================================================================
#  Makefile (Poprawiony dla Arch Linux / GCC 14)
# ============================================================================

CC       = gcc

# ZMIANA 1: Zmiana -O6 na -O3 oraz dodanie flag wyłączających błędy dla starego kodu C
CFLAGS   = -O3 -DNDEBUG -DPERMUTE_NODES -I ../../lib -I ../../lib/ll-core/include \
           -Wno-error -Wno-implicit-function-declaration -Wno-return-type -Wno-int-conversion

LDFLAGS  = 
LOADLIBS = -lm        

LIB      = ../../lib/

all: spgrid.exe

spgrid.exe: spgrid.c $(LIB)random.c $(LIB)permute.c
	# ZMIANA 2: $(LOADLIBS) przesunięte na sam koniec linii!
	$(CC) $(CFLAGS) -o spgrid.exe spgrid.c -I$(LIB) ../../lib/ll-core/src/*.c $(LOADLIBS)

clean:
	rm -f *~ spgrid.exe