cmake_minimum_required(VERSION 3.24)
project(comp_phys_book LANGUAGES Fortran)

# Set Fortran compiler flags
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -Wall -Wextra -fcheck=all")

# compiler agnostic include dirs for compiler-specific install paths
execute_process(
	COMMAND find /usr/local/include -type d
	OUTPUT_VARIABLE plotting_include_dirs
	OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REPLACE "\n" ";" plotting_include_dirs "${plotting_include_dirs}")

# Find installed packages
find_package(ferror REQUIRED)
find_package(collections REQUIRED)
find_package(fstring REQUIRED)
find_package(geompack REQUIRED)
find_package(forimage REQUIRED)
find_package(forcolormap REQUIRED)
find_package(fplot REQUIRED)

# Default plotting libraries
set(PLOT_LIBS fplot collections fstring geompack forimage forcolormap ferror)

# function to handle adding executables with fplot as a dependency
function(add_plotting_executable target_name source_file)
    add_executable(${target_name} ${source_file})
    
    target_include_directories(${target_name} PRIVATE ${plotting_include_dirs})
        
    # Add any extra libraries passed as additional arguments
    target_link_libraries(${target_name} ${PLOT_LIBS} ${ARGN})
endfunction()

# Define executables
add_executable(00_hello src/00_hello.f90)
add_executable(01_average src/01_average.f90)
add_plotting_executable(02_plotting_test src/02_plotting_test.f90)
add_plotting_executable(03_plotting_classic_curves src/03_plotting_classic_curves.f90)
