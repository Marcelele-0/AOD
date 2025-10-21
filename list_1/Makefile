# Compiler settings
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -Iinclude
LDFLAGS = 

# Directories
SRC_DIR = src
INC_DIR = include
BUILD_DIR = build
BIN_DIR = bin

# Source files
COMMON_SOURCES = $(SRC_DIR)/dfs.cpp $(SRC_DIR)/bfs.cpp $(SRC_DIR)/toposort.cpp $(SRC_DIR)/scc.cpp $(SRC_DIR)/biparte.cpp

# Executables
EX1_TARGET = $(BIN_DIR)/ex1.exe
EX2_TARGET = $(BIN_DIR)/ex2.exe
EX3_TARGET = $(BIN_DIR)/ex3.exe
EX4_TARGET = $(BIN_DIR)/ex4.exe

# Object files
EX1_OBJECTS = $(BUILD_DIR)/main_ex1.o $(BUILD_DIR)/dfs.o $(BUILD_DIR)/bfs.o
EX2_OBJECTS = $(BUILD_DIR)/main_ex2.o $(BUILD_DIR)/toposort.o
EX3_OBJECTS = $(BUILD_DIR)/main_ex3.o $(BUILD_DIR)/scc.o $(BUILD_DIR)/dfs.o
EX4_OBJECTS = $(BUILD_DIR)/main_ex4.o $(BUILD_DIR)/biparte.o $(BUILD_DIR)/bfs.o

# Default target - build all executables
all: $(EX1_TARGET) $(EX2_TARGET) $(EX3_TARGET) $(EX4_TARGET)
	@echo All exercises built successfully!

# Create necessary directories
$(BUILD_DIR):
	@if not exist "$(BUILD_DIR)" mkdir "$(BUILD_DIR)"

$(BIN_DIR):
	@if not exist "$(BIN_DIR)" mkdir "$(BIN_DIR)"

# Build Exercise 1
$(EX1_TARGET): $(EX1_OBJECTS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo Built exercise 1: $@

# Build Exercise 2
$(EX2_TARGET): $(EX2_OBJECTS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo Built exercise 2: $@

# Build Exercise 3
$(EX3_TARGET): $(EX3_OBJECTS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo Built exercise 3: $@

# Build Exercise 4
$(EX4_TARGET): $(EX4_OBJECTS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo Built exercise 4: $@

# Compile object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Individual build targets
ex1: $(EX1_TARGET)
ex2: $(EX2_TARGET)
ex3: $(EX3_TARGET)
ex4: $(EX4_TARGET)

# Run targets with test cases
# Exercise 1 - Uses test cases from folder 4
run-ex1: $(EX1_TARGET)
	@echo Running Exercise 1...
	@$(EX1_TARGET)

# Exercise 2 - Uses test cases from folder 2
run-ex2: $(EX2_TARGET)
	@echo Running Exercise 2...
	@$(EX2_TARGET)

# Exercise 3 - Uses test cases from folder 3
run-ex3: $(EX3_TARGET)
	@echo Running Exercise 3...
	@$(EX3_TARGET)

# Exercise 4 - Uses test cases from folder 4
run-ex4: $(EX4_TARGET)
	@echo Running Exercise 4...
	@$(EX4_TARGET)

# Run all exercises with specific test files (examples)
# Usage: make test-ex1-1 (runs exercise 1 with test case 1)
test-ex1-1: $(EX1_TARGET)
	@echo Testing Exercise 1 with u4a-1.txt...
	@$(EX1_TARGET) < test_cases/4/u4a-1.txt

test-ex1-2: $(EX1_TARGET)
	@echo Testing Exercise 1 with u4a-2.txt...
	@$(EX1_TARGET) < test_cases/4/u4a-2.txt

test-ex2-1: $(EX2_TARGET)
	@echo Testing Exercise 2 with g2a-1.txt...
	@$(EX2_TARGET) < test_cases/2/g2a-1.txt

test-ex2-2: $(EX2_TARGET)
	@echo Testing Exercise 2 with g2a-2.txt...
	@$(EX2_TARGET) < test_cases/2/g2a-2.txt

test-ex3-1: $(EX3_TARGET)
	@echo Testing Exercise 3 with g3-1.txt...
	@$(EX3_TARGET) < test_cases/3/g3-1.txt

test-ex3-2: $(EX3_TARGET)
	@echo Testing Exercise 3 with g3-2.txt...
	@$(EX3_TARGET) < test_cases/3/g3-2.txt

test-ex4-1: $(EX4_TARGET)
	@echo Testing Exercise 4 with u4a-1.txt...
	@$(EX4_TARGET) < test_cases/4/u4a-1.txt

test-ex4-2: $(EX4_TARGET)
	@echo Testing Exercise 4 with u4a-2.txt...
	@$(EX4_TARGET) < test_cases/4/u4a-2.txt

# Run all tests for an exercise
test-ex1-all: $(EX1_TARGET)
	@echo Running all Exercise 1 tests...
	@for %%f in (test_cases\4\u4a-*.txt) do @(echo Testing %%f && $(EX1_TARGET) < %%f && echo.)

test-ex2-all: $(EX2_TARGET)
	@echo Running all Exercise 2 tests...
	@for %%f in (test_cases\2\g2a-*.txt) do @(echo Testing %%f && $(EX2_TARGET) < %%f && echo.)

test-ex3-all: $(EX3_TARGET)
	@echo Running all Exercise 3 tests...
	@for %%f in (test_cases\3\g3-*.txt) do @(echo Testing %%f && $(EX3_TARGET) < %%f && echo.)

test-ex4-all: $(EX4_TARGET)
	@echo Running all Exercise 4 tests...
	@for %%f in (test_cases\4\u4a-*.txt) do @(echo Testing %%f && $(EX4_TARGET) < %%f && echo.)

# Run all exercises
run-all: run-ex1 run-ex2 run-ex3 run-ex4

# Clean build artifacts
clean:
	@if exist "$(BUILD_DIR)" rmdir /s /q "$(BUILD_DIR)"
	@if exist "$(BIN_DIR)" rmdir /s /q "$(BIN_DIR)"
	@echo Cleaned build artifacts

# Rebuild everything
rebuild: clean all

# Help target
help:
	@echo Available targets:
	@echo   all          - Build all exercises (default)
	@echo   ex1, ex2, ex3, ex4 - Build individual exercises
	@echo   run-ex1, run-ex2, run-ex3, run-ex4 - Run individual exercises
	@echo   run-all      - Run all exercises
	@echo   test-ex1-1   - Test exercise 1 with specific test case
	@echo   test-ex2-1   - Test exercise 2 with specific test case
	@echo   test-ex3-1   - Test exercise 3 with specific test case
	@echo   test-ex4-1   - Test exercise 4 with specific test case
	@echo   test-ex1-all - Run all tests for exercise 1
	@echo   test-ex2-all - Run all tests for exercise 2
	@echo   test-ex3-all - Run all tests for exercise 3
	@echo   test-ex4-all - Run all tests for exercise 4
	@echo   clean        - Remove build artifacts
	@echo   rebuild      - Clean and rebuild all
	@echo   help         - Show this help message

.PHONY: all ex1 ex2 ex3 ex4 run-ex1 run-ex2 run-ex3 run-ex4 run-all clean rebuild help \
        test-ex1-1 test-ex1-2 test-ex2-1 test-ex2-2 test-ex3-1 test-ex3-2 test-ex4-1 test-ex4-2 \
        test-ex1-all test-ex2-all test-ex3-all test-ex4-all
