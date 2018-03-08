#!/bin/bash

set -o errexit

mkdir build
pushd build

cmake -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DLLVM_PARALLEL_LINK_JOBS=1 \
      -DLLVM_PARALLEL_COMPILE_JOBS=6 \
      ..

ninja ${VERBOSE_NINJA} clang-{format,tidy} include-what-you-use

mkdir -p ${PREFIX}/bin
cp bin/clang-{format,tidy} bin/include-what-you-use ${PREFIX}/bin
popd

pushd tools/clang/tools/include-what-you-use
cp fix_includes.py iwyu_tool.py ${PREFIX}/bin
mkdir -p ${PREFIX}/share/include-what-you-use
cp *.imp ${PREFIX}/share/include-what-you-use
popd
