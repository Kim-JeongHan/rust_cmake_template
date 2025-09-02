cmake_minimum_required(VERSION 3.15)
project(rust_cmake)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set Rust environment variables
set(ENV{PATH} "$ENV{HOME}/.cargo/bin:$ENV{PATH}")

# Find Rust tools with absolute paths
find_program(CARGO_EXECUTABLE cargo 
    PATHS $ENV{HOME}/.cargo/bin
    NO_DEFAULT_PATH
    REQUIRED)
find_program(RUSTC_EXECUTABLE rustc 
    PATHS $ENV{HOME}/.cargo/bin
    NO_DEFAULT_PATH
    REQUIRED)

# Set Rust toolchain for Corrosion
set(Rust_TOOLCHAIN "stable-x86_64-unknown-linux-gnu")
set(Rust_COMPILER ${RUSTC_EXECUTABLE})
set(Rust_CARGO ${CARGO_EXECUTABLE})
set(Rust_CARGO_TARGET_DIR ${CMAKE_CURRENT_SOURCE_DIR}/rust_lib/target)

message(STATUS "Found Cargo: ${CARGO_EXECUTABLE}")
message(STATUS "Found Rustc: ${RUSTC_EXECUTABLE}")
message(STATUS "Rust Toolchain: ${Rust_TOOLCHAIN}")

include(FetchContent)
FetchContent_Declare(
    Corrosion
    GIT_REPOSITORY https://github.com/corrosion-rs/corrosion.git
    GIT_TAG v0.3.5
    GIT_SHALLOW ON
)
FetchContent_MakeAvailable(Corrosion)

corrosion_import_crate(
    MANIFEST_PATH rust_lib/Cargo.toml
    CRATES rust_math_lib
)

# Set up header generation with cbindgen
set(RUST_HEADER_DIR ${CMAKE_CURRENT_BINARY_DIR}/include)
set(RUST_HEADER_FILE ${RUST_HEADER_DIR}/rust_math_lib.h)
set(RUST_LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/rust_lib)

# Find cbindgen executable
find_program(CBINDGEN_EXECUTABLE cbindgen 
    PATHS $ENV{HOME}/.cargo/bin
    REQUIRED)

# Custom command to generate C header using cbindgen
add_custom_command(
    OUTPUT ${RUST_HEADER_FILE}
    COMMAND ${CBINDGEN_EXECUTABLE} 
        --config ${RUST_LIB_DIR}/cbindgen.toml 
        --crate rust_math_lib 
        --output ${RUST_HEADER_FILE}
    WORKING_DIRECTORY ${RUST_LIB_DIR}
    DEPENDS ${RUST_LIB_DIR}/src/lib.rs ${RUST_LIB_DIR}/cbindgen.toml
    COMMENT "Generating C header with cbindgen"
    VERBATIM
)

# Custom target for header generation
add_custom_target(generate_rust_header
    DEPENDS ${RUST_HEADER_FILE}
)

include_directories(${RUST_HEADER_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
add_executable(cpp_example src/main.cpp)
target_link_libraries(cpp_example rust_math_lib)
add_dependencies(cpp_example generate_rust_header)

set_target_properties(cpp_example PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)
