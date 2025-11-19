## Minimal POSIX Makefile for AOD lab exercises

CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -Iinclude
LDFLAGS :=

SRC_DIR := src
BUILD_DIR := build
BIN_DIR := bin

# Map exercises to their object lists
EX1_OBJS := $(BUILD_DIR)/main_ex1.o $(BUILD_DIR)/dfs.o $(BUILD_DIR)/bfs.o
EX2_OBJS := $(BUILD_DIR)/main_ex2.o $(BUILD_DIR)/toposort.o
EX3_OBJS := $(BUILD_DIR)/main_ex3.o $(BUILD_DIR)/scc.o $(BUILD_DIR)/dfs.o $(BUILD_DIR)/toposort.o
EX4_OBJS := $(BUILD_DIR)/main_ex4.o $(BUILD_DIR)/biparte.o $(BUILD_DIR)/bfs.o

EX1_BIN := $(BIN_DIR)/ex1.exe
EX2_BIN := $(BIN_DIR)/ex2.exe
EX3_BIN := $(BIN_DIR)/ex3.exe
EX4_BIN := $(BIN_DIR)/ex4.exe

# Discover all .cpp files under src for generic compilation rule
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))

.PHONY: all ex1 ex2 ex3 ex4 run-ex1 run-ex2 run-ex3 run-ex4 test-ex1-all test-ex2-all test-ex3-all test-ex4-all clean help

all: $(EX1_BIN) $(EX2_BIN) $(EX3_BIN) $(EX4_BIN)
	@echo "All exercises built"

# Build binaries
$(EX1_BIN): $(EX1_OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo Built $@

$(EX2_BIN): $(EX2_OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo Built $@

$(EX3_BIN): $(EX3_OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo Built $@

$(EX4_BIN): $(EX4_OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo Built $@

# Generic rule to compile .cpp -> .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Directories
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Individual build targets
ex1: $(EX1_BIN)
ex2: $(EX2_BIN)
ex3: $(EX3_BIN)
ex4: $(EX4_BIN)

# Run targets
run-ex1: ex1
	@echo "Running ex1"
	@$(EX1_BIN)

run-ex2: ex2
	@echo "Running ex2"
	@$(EX2_BIN)

run-ex3: ex3
	@echo "Running ex3"
	@$(EX3_BIN)

run-ex4: ex4
	@echo "Running ex4"
	@$(EX4_BIN)

# Test-all targets (POSIX shell loops)
# Each will run the executable with every matching test case in test_cases/<n>/

test-ex1-all: ex1
	@echo "Running all tests for ex1..."
	@for f in test_cases/1/*.txt; do \
		echo "=== $$f ==="; \
		type=$$(sed -n '1p' "$$f" 2>/dev/null || true); \
		nv=$$(sed -n '2p' "$$f" 2>/dev/null || true); \
		ne=$$(sed -n '3p' "$$f" 2>/dev/null || true); \
		echo "Graph type: $$type  Vertices: $$nv  Edges: $$ne"; \
		start=$$(date +%s%3N); \
		$(EX1_BIN) < "$$f"; \
		end=$$(date +%s%3N); \
		elapsed=$$((end - start)); \
		echo "Elapsed: $$elapsed ms"; \
		echo; \
	done

test-ex2-all: ex2
	@echo "Running all tests for ex2..."
	@for f in test_cases/2/*.txt; do \
		echo "=== $$f ==="; \
		type=$$(sed -n '1p' "$$f" 2>/dev/null || true); \
		nv=$$(sed -n '2p' "$$f" 2>/dev/null || true); \
		ne=$$(sed -n '3p' "$$f" 2>/dev/null || true); \
		echo "Graph type: $$type  Vertices: $$nv  Edges: $$ne"; \
		start=$$(date +%s%3N); \
		$(EX2_BIN) < "$$f"; \
		end=$$(date +%s%3N); \
		elapsed=$$((end - start)); \
		echo "Elapsed: $$elapsed ms"; \
		echo; \
	done

test-ex3-all: ex3
	@echo "Running all tests for ex3..."
	@for f in test_cases/3/*.txt; do \
		echo "=== $$f ==="; \
		type=$$(sed -n '1p' "$$f" 2>/dev/null || true); \
		nv=$$(sed -n '2p' "$$f" 2>/dev/null || true); \
		ne=$$(sed -n '3p' "$$f" 2>/dev/null || true); \
		echo "Graph type: $$type  Vertices: $$nv  Edges: $$ne"; \
		start=$$(date +%s%3N); \
		$(EX3_BIN) < "$$f"; \
		end=$$(date +%s%3N); \
		elapsed=$$((end - start)); \
		echo "Elapsed: $$elapsed ms"; \
		echo; \
	done

test-ex4-all: ex4
	@echo "Running all tests for ex4..."
	@for f in test_cases/4/*.txt; do \
		echo "=== $$f ==="; \
		type=$$(sed -n '1p' "$$f" 2>/dev/null || true); \
		nv=$$(sed -n '2p' "$$f" 2>/dev/null || true); \
		ne=$$(sed -n '3p' "$$f" 2>/dev/null || true); \
		echo "Graph type: $$type  Vertices: $$nv  Edges: $$ne"; \
		start=$$(date +%s%3N); \
		$(EX4_BIN) < "$$f"; \
		end=$$(date +%s%3N); \
		elapsed=$$((end - start)); \
		echo "Elapsed: $$elapsed ms"; \
		echo; \
	done

# Clean
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR) outputs
	@echo "Cleaned"

help:
	@echo "Available targets:"
	@echo "  all         - build all exercises"
	@echo "  ex1..ex4    - build individual exercises"
	@echo "  run-ex1..4  - run an exercise"
	@echo "  test-exN-all - run all test cases for exercise N"
	@echo "  clean       - remove build artifacts"