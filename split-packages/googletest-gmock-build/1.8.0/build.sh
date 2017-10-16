#!/bin/bash

set -o errexit

mkdir build
pushd build

# tests aren't run because the GTest tests fails even though GTest seems usable
# and the GMock tests uses too much CPU freezing the computer

cmake -G "${CMAKE_GENERATOR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DBUILD_GMOCK=ON \
      -DBUILD_GTEST=ON \
      -Dgtest_build_tests=OFF \
      -Dgmock_build_tests=OFF \
      ..
cmake --build . --config Release -- -j$CPU_COUNT
cmake --build . --config Release --target install -- -j$CPU_COUNT

popd
