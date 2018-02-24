#!/bin/bash

set -o errexit

mkdir build
cd build

cmake -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DLLVM_PARALLEL_LINK_JOBS=1 \
      -DLLVM_PARALLEL_COMPILE_JOBS=6 \
      ..

# ninja ${VERBOSE_NINJA} install
ninja clang-{format,tidy}

mkdir -p ${PREFIX}/bin
cp bin/clang-{format,tidy} ${PREFIX}/bin
