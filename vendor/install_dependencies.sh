#!/bin/bash
set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "Installing Fortran dependencies"
echo "=========================================="

# Function to apply patches
apply_patches() {
    echo ""
    echo "Applying patches..."
    
    # Fix collections typo
    if [ -f "collections/CMakeLists.txt" ]; then
        echo "Patching collections/CMakeLists.txt..."
        sed -i 's/CMAKE_INSALL_LIBDIR/CMAKE_INSTALL_LIBDIR/g' collections/CMakeLists.txt
    fi
    
    # Fix fstring config
    if [ -f "fstring/install/fstringConfig.cmake.in" ]; then
        echo "Patching fstring/install/fstringConfig.cmake.in..."
        sed -i 's/if (NOT TARGET forcolormap)/if (NOT TARGET fstring)/g' fstring/install/fstringConfig.cmake.in
    fi
    
    # Fix geompack - add install target
    if [ -f "geompack/CMakeLists.txt" ]; then
        echo "Patching geompack..."
        
        # Create the config template file
        mkdir -p geompack/cmake
        cat > geompack/cmake/geompackConfig.cmake.in << 'EOF'
@PACKAGE_INIT@

include("${CMAKE_CURRENT_LIST_DIR}/geompackTargets.cmake")

check_required_components(geompack)
EOF
        
        # Replace the entire CMakeLists.txt with the patched version
        cat > geompack/CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.24)
project(
    geompack
    LANGUAGES Fortran
    VERSION 1.0.2
)

# Get helper macros and functions
include("${PROJECT_SOURCE_DIR}/cmake/helper.cmake")

# Configure everything
add_subdirectory(configure)

# Source
add_subdirectory(src)
add_fortran_library(
    ${PROJECT_NAME}
    ${PROJECT_INCLUDE_DIR}
    ${CMAKE_INSTALL_INCLUDEDIR}
    ${PROJECT_VERSION}
    ${PROJECT_VERSION_MAJOR}
    ${GEOMPACK_SOURCES}
)

# Installation
include(GNUInstallDirs)
install_library(
    ${PROJECT_NAME}
    ${CMAKE_INSTALL_LIBDIR}
    ${CMAKE_INSTALL_BINDIR}
    ${PROJECT_INCLUDE_DIR}
    ${CMAKE_INSTALL_PREFIX}
)

# Install CMake package configuration files
include(CMakePackageConfigHelpers)

# Create the config file
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Create the version file
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

# Install the config and version files
install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Export targets
install(
    EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Testing
option(BUILD_TESTING "Build tests")
include(CTest)
message(STATUS "Build tests: ${BUILD_TESTING}")
if (BUILD_TESTING)
    enable_testing()
    add_subdirectory(test)
endif()
EOF
    fi
    
    echo "Patches applied successfully!"
}

# Function to build and install a package
build_and_install() {
    local package=$1
    echo ""
    echo "=========================================="
    echo "Building and installing: $package"
    echo "=========================================="
    
    cd "$SCRIPT_DIR/$package"
    
    # Clean previous build
    rm -rf build
    mkdir -p build
    cd build
    
    # Configure and build
    cmake ..
    make -j$(nproc)
    
    # Install
    sudo make install
    
    echo "$package installed successfully!"
}

# Apply all patches first
apply_patches

# Build and install in dependency order
build_and_install "ferror"
build_and_install "collections"
build_and_install "fstring"
build_and_install "forcolormap"
build_and_install "geompack"
build_and_install "fplot"

echo ""
echo "=========================================="
echo "All dependencies installed successfully!"
echo "=========================================="
echo ""
echo "You can now build your project with:"
echo "  cd .."
echo "  cmake -B build"
echo "  cmake --build build"
