# Rust-CMake Integration with cbindgen and Corrosion

A comprehensive example demonstrating how to integrate Rust libraries with C++ projects using **cbindgen** for C header generation and **Corrosion** for CMake integration.

## Overview

This project showcases the complete workflow of:
- Writing Rust functions that can be called from C/C++
- Automatically generating C header files with **cbindgen**
- Integrating Rust libraries into CMake builds with **Corrosion**
- Building and running a C++ application that uses Rust functions

## Project Structure

```
rust_cmake/
├── rust_lib/                   # Rust library
│   ├── src/
│   │   └── lib.rs             # Rust source code with exported functions
│   ├── Cargo.toml             # Rust project configuration
│   ├── cbindgen.toml          # cbindgen configuration
│   └── build.rs               # Build script for header generation
├── src/
│   └── main.cpp               # C++ application using Rust functions
├── scripts/
│   └── build.sh               # CMake build script
├── CMakeLists.txt             # CMake configuration with Corrosion
├── .gitignore                 # Git ignore rules
└── README.md                  # This file
```

## Features

### Rust Library Functions

The Rust library (`rust_lib`) provides two simple mathematical functions:

1. **`add_numbers(a, b)`** - Adds two integers
2. **`factorial(n)`** - Calculates the factorial of a number

### Key Technologies

- **cbindgen**: Automatically generates C header files from Rust code
- **Corrosion**: CMake integration for Rust projects
- **Rust 2024 Edition**: Uses modern Rust with `#[unsafe(no_mangle)]` syntax
- **CMake 3.15+**: Modern CMake build system

## Prerequisites

- **Rust** (1.70+) with Cargo
- **CMake** (3.15+)
- **C++ compiler** (GCC, Clang, or MSVC)
- **Git** (for fetching Corrosion)

## Quick Start

```bash
# Navigate to the project directory
cd rust_cmake

# Run the CMake build script
./scripts/build.sh

# Run the demo
./build/bin/cpp_example
```

## Manual Build Process

If you prefer to build manually:

### 1. Build Rust Library

```bash
cd rust_lib
cargo build --release
cd ..
```

### 2. Configure and Build with CMake

```bash
mkdir build && cd build
cmake ..
make -j$(nproc)
```

### 3. Run the Application

```bash
./bin/cpp_example
```

## How It Works

### 1. Rust Code with C Exports

```rust
/// Add two integers
#[unsafe(no_mangle)]
pub extern "C" fn add_numbers(a: i32, b: i32) -> i32 {
    a + b
}

/// Calculate the factorial of a number
#[unsafe(no_mangle)]
pub extern "C" fn factorial(n: u32) -> u64 {
    // Implementation...
}
```

### 2. cbindgen Configuration

The `cbindgen.toml` file configures automatic C header generation:

```toml
language = "C"
include_guard = "RUST_MATH_LIB_H"
documentation = true
```

### 3. CMake with Corrosion

```cmake
# Fetch Corrosion
FetchContent_Declare(
    Corrosion
    GIT_REPOSITORY https://github.com/corrosion-rs/corrosion.git
    GIT_TAG v0.5
)

# Import Rust crate
corrosion_import_crate(
    MANIFEST_PATH rust_lib/Cargo.toml
    CRATES rust_math_lib
)

# Link with C++ application
target_link_libraries(cpp_example rust_math_lib)
```

### 4. C++ Integration

```cpp
#include "rust_math_lib.h"

int main() {
    int sum = add_numbers(15, 27);
    uint64_t fact = factorial(5);
    // Use the functions...
}
```

## Generated Files

After building, the following files are automatically generated:

- `include/rust_math_lib.h` - C header file (by cbindgen)
- `rust_lib/target/release/librust_math_lib.a` - Static library
- `rust_lib/target/release/librust_math_lib.so` - Dynamic library
- `build/bin/cpp_example` - Final executable

## Development Workflow

1. **Modify Rust code** in `rust_lib/src/lib.rs`
2. **Update cbindgen config** if needed in `rust_lib/cbindgen.toml`
3. **Rebuild** using `./scripts/build.sh`
4. **Test** with `cd build && ./bin/cpp_example`

## Troubleshooting

### Common Issues

1. **"cbindgen not found"**: Install with `cargo install cbindgen`
2. **"Corrosion fetch failed"**: Check internet connection and Git access
3. **"Header not found"**: Ensure the build process completed successfully

### Clean Build

```bash
# Clean everything and rebuild
rm -rf build rust_lib/target include
./scripts/build.sh
```

## Key Advantages

- **Automatic Header Generation**: No manual C header maintenance
- **Type Safety**: cbindgen ensures C headers match Rust definitions
- **Modern Build System**: CMake + Corrosion handles complex dependencies
- **Cross-Platform**: Works on Linux, macOS, and Windows
- **Performance**: Zero-cost Rust integration with C/C++

## Learn More

- [cbindgen Documentation](https://github.com/eqrion/cbindgen)
- [Corrosion Documentation](https://github.com/corrosion-rs/corrosion)
- [Rust FFI Guide](https://doc.rust-lang.org/nomicon/ffi.html)
- [CMake Documentation](https://cmake.org/documentation/)

## License

This project is provided as an educational example. Feel free to use it as a starting point for your own Rust-C++ integration projects.
