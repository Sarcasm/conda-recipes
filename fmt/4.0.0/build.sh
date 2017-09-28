#!/bin/bash

set -o errexit

mkdir build
pushd build
cmake -G "${CMAKE_GENERATOR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DFMT_DOC=OFF \
      ..
cmake --build . --config Release -- -j${CPU_COUNT}
ctest --build-config Release -j$CPU_COUNT
cmake --build . --config Release --target install -- -j$CPU_COUNT
popd
