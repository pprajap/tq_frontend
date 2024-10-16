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
find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Network Widgets)

# Add executable target for the application
qt_add_executable(apptq_frontend
    main.cpp
    CppInterface.h
    CppInterface.cpp
    resources.qrc
)

# Define flags based on the deployment type
target_compile_definitions(apptq_frontend PRIVATE CLOUD_DEPLOYMENT)

# Add QML module to the target
qt_add_qml_module(apptq_frontend
    URI tq_frontend
    VERSION 1.0
    QML_FILES
        main.qml
)

# Add resources to the target
qt_add_resources(apptq_frontend "resources"
    PREFIX "/"
    FILES main.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
# Set target properties for macOS and Windows
set_target_properties(apptq_frontend PROPERTIES
    # MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apptq_frontend
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Link target with required Qt6 libraries
target_link_libraries(apptq_frontend
    PRIVATE Qt6::Core Qt6::Quick Qt::QuickControls2 Qt6::Network Qt6::Widgets
)

# Include GNUInstallDirs module for standard installation directories
include(GNUInstallDirs)

# Install target with specified destinations
install(TARGETS apptq_frontend
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
