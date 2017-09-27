#!/bin/bash

set -o errexit

mkdir build
pushd build
cmake -G "${CMAKE_GENERATOR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      ..
cmake --build . --config Release -- -j$CPU_COUNT
ctest --build-config Release -j$CPU_COUNT
cmake --build . --config Release --target install -- -j$CPU_COUNT
popd
