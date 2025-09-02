#!/bin/bash

set -e

BUILD_TYPE="${1:-Release}"

if [[ "$BUILD_TYPE" != "Debug" && "$BUILD_TYPE" != "Release" ]]; then
    echo "Usage: $0 [Debug|Release]"
    echo "Default: Release"
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build"

export PATH="$HOME/.cargo/bin:$PATH"

echo "Building in $BUILD_TYPE mode..."

if [ -d "${BUILD_DIR}" ]; then
    rm -rf "${BUILD_DIR}"
fi

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_BUILD_TYPE="$BUILD_TYPE" ..
cmake --build . --parallel $(nproc)
