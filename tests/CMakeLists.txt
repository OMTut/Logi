# Test configuration
find_package(Qt6 REQUIRED COMPONENTS Test Network Core Gui)

# Create test executable
qt_add_executable(LogiTests
    tst_updatechecker.cpp
    MockUpdateServer.cpp
    MockUpdateServer.h
    ../src/UpdateChecker.cpp
    ../src/UpdateChecker.h
)

# Link required Qt modules
target_link_libraries(LogiTests PRIVATE
    Qt6::Test
    Qt6::Network  
    Qt6::Core
    Qt6::Gui
)

# Add include directories
target_include_directories(LogiTests PRIVATE 
    ../src
    .
)

# Add the test to CTest
add_test(NAME UpdateCheckerTests COMMAND LogiTests)
