# --- Configuration ---
FC = gfortran
FCFLAGS = -g -Wall -Wextra -fcheck=all -c -J$(BUILDDIR) # -J flag puts .mod files in build dir
BUILDDIR = build
SRCDIR = src

.PHONY: all clean

# --- Executable List ---

# Define executables and their required sources (relative to SRCDIR)
# Executable 00: hello - A "hello, world!" 2-liner
EXE00_NAME = 00_hello
EXE00_SRCS = $(SRCDIR)/00_hello.f90

# Executable 01: average - Read two numbers from stdin and average them
EXE01_NAME = 01_average
EXE01_SRCS = $(SRCDIR)/01_average.f90

# List all final executables
PROGRAMS = $(EXE00_NAME) $(EXE01_NAME)

# --- Automatic Variable Generation ---

# Function to transform source paths to object paths within the build directory
# Usage: $(call SRC_TO_OBJ, $(EXE1_SRCS))
define SRC_TO_OBJ
$(patsubst $(SRCDIR)/%.f90,$(BUILDDIR)/%.o,$1)
endef

# Generate object file lists for each program
EXE00_OBJS = $(call SRC_TO_OBJ, $(EXE00_SRCS))
EXE01_OBJS = $(call SRC_TO_OBJ, $(EXE01_SRCS))

# Collect all object files needed across all programs
ALL_OBJS = $(sort $(EXE00_OBJS) $(EXE01_OBJS))

# --- Build Rules ---

# Default target: build all programs
all: $(PROGRAMS)

# Rule to ensure the build directory exists before any compilation happens
$(BUILDDIR):
	mkdir -p $(BUILDDIR)

# Generic rule to link a program
$(EXE00_NAME): $(EXE00_OBJS)
	$(FC) $^ -o $@

$(EXE01_NAME): $(EXE01_OBJS)
	$(FC) $^ -o $@

# Generic pattern rule to compile any .f90 into a .o in the build directory
# The | $(BUILDDIR) ensures the directory exists first (order-only prerequisite)
$(BUILDDIR)/%.o: $(SRCDIR)/%.f90 | $(BUILDDIR)
	$(FC) $(FCFLAGS) $< -o $@

# --- Utility Targets ---

# Delete the build outputs
clean:
	rm -rf $(BUILDDIR) $(PROGRAMS)
