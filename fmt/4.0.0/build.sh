#!/bin/bash

set -o errexit

mkdir build
pushd build
cmake -G "${CMAKE_GENERATOR}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DFMT_DOC=OFF \
      ..
cmake --build . --config Release -- -j${CPU_COUNT}
cmake --build . --config Release --target test
cmake --build . --config Release --target install
popd
