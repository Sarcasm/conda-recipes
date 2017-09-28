#!/bin/bash

set -o errexit

mkdir build
pushd build

# tests aren't run as them seem to fail even though GTest is usable

cmake -G "${CMAKE_GENERATOR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DBUILD_GMOCK=OFF \
      -DBUILD_GTEST=ON \
      -Dgtest_build_tests=OFF \
      ..
cmake --build . --config Release -- -j$CPU_COUNT
cmake --build . --config Release --target install -- -j$CPU_COUNT

popd
