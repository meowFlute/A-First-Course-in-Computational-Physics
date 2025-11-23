cmake_minimum_required(VERSION 3.24)
project(comp_phys_book LANGUAGES Fortran)

# Set Fortran compiler flags
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -Wall -Wextra -fcheck=all")

# compiler agnostic include dirs for compiler-specific install paths
execute_process(
	COMMAND find /usr/local/include -type d
	OUTPUT_VARIABLE all_include_dirs
	OUTPUT_STRIP_TRAILING_WHITESPACE
)
string(REPLACE "\n" ";" all_include_dirs "${all_include_dirs}")

# Find installed packages
find_package(ferror REQUIRED)
find_package(collections REQUIRED)
find_package(fstring REQUIRED)
find_package(geompack REQUIRED)
find_package(forimage REQUIRED)
find_package(forcolormap REQUIRED)
find_package(fplot REQUIRED)

# Define executables
add_executable(00_hello src/00_hello.f90)
add_executable(01_average src/01_average.f90)
add_executable(02_plotting_test src/02_plotting_test.f90)

target_include_directories(02_plotting_test PRIVATE
	${all_include_dirs}
)

target_link_libraries(02_plotting_test 
	fplot
    	collections
    	fstring
    	geompack
    	forimage
	forcolormap
	ferror
)
