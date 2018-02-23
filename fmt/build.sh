#!/bin/bash

set -o errexit

mkdir build
cd build

cmake -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DFMT_DOC=OFF \
      ..

ninja ${VERBOSE_NINJA}
ctest --output-on-failure -j$CPU_COUNT
ninja ${VERBOSE_NINJA} install

