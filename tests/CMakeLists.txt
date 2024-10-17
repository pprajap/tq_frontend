# Minimum CMake version required
cmake_minimum_required(VERSION 3.16)

# Project name and version
project(tq_frontend VERSION 0.1 LANGUAGES CXX)

# Enable automatic MOC (Meta-Object Compiler) for Qt
set(CMAKE_AUTOMOC ON)

# Set C++ standard to C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find required Qt6 packages
find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Network Widgets Test)

# Add test executable target
qt_add_executable(tq_frontend_tests
    test_ex.cpp
    ../CppInterface.h
    ../CppInterface.cpp
)

# Specify include directories
target_include_directories(tq_frontend_tests
    PRIVATE ${CMAKE_SOURCE_DIR}/..
)

# Link test target with required Qt6 libraries
target_link_libraries(tq_frontend_tests
    PRIVATE Qt6::Core Qt6::Quick Qt6::QuickControls2 Qt6::Network Qt6::Widgets Qt6::Test
)

# Enable testing
enable_testing()

# Add test
add_test(NAME tq_frontend_tests COMMAND tq_frontend_tests)
