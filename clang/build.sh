#!/bin/bash

set -o errexit

mkdir -v build
pushd build

# The ones you need for ARM are: ``libtinfo``, ``zlib1g``,
# ``libxml2`` and ``liblzma``. In the Debian repository you'll
# find downloads for all architectures.
#
# Turn off libxml? used only for testing code apparently, see CLANG_HAVE_LIBXML
#
# if (LLVM_ENABLE_LIBXML2 STREQUAL "FORCE_ON" AND NOT LLVM_LIBXML2_ENABLED)
#   message(FATAL_ERROR "Failed to congifure libxml2")
# endif()
#
# Disable enables colors?
# option(LLVM_ENABLE_TERMINFO "Use terminfo database if available." ON)
#
# incorrect cache variables
# grep / build/CMakeCache.txt | egrep -v '(^//|/home/papin_g/miniconda3/conda-bld)'
# grep -nH --color /usr build/*.ninja
#
# Backtrace_INCLUDE_DIR:PATH=/usr/include
# CMAKE_AR:FILEPATH=/usr/bin/ar
# CMAKE_C_COMPILER_AR:FILEPATH=/usr/bin/gcc-ar
# CMAKE_C_COMPILER_RANLIB:FILEPATH=/usr/bin/gcc-ranlib
# CMAKE_CXX_COMPILER_AR:FILEPATH=/usr/bin/gcc-ar
# CMAKE_CXX_COMPILER_RANLIB:FILEPATH=/usr/bin/gcc-ranlib
# CMAKE_INSTALL_OLDINCLUDEDIR:PATH=/usr/include
# CMAKE_LINKER:FILEPATH=/usr/bin/ld
# CMAKE_NM:FILEPATH=/usr/bin/nm
# CMAKE_OBJCOPY:FILEPATH=/usr/bin/objcopy
# CMAKE_OBJDUMP:FILEPATH=/usr/bin/objdump
# CMAKE_RANLIB:FILEPATH=/usr/bin/ranlib
# CMAKE_STRIP:FILEPATH=/usr/bin/strip
# DL_LIBRARY_PATH:FILEPATH=/usr/lib/libdl.so
# GOLD_EXECUTABLE:FILEPATH=/usr/bin/ld.gold
# GO_EXECUTABLE:FILEPATH=/usr/bin/go
# ICONV_LIBRARY_PATH:FILEPATH=/usr/lib/libc.so

# examples:
# /home/papin_g/dev/github.com/AnacondaRecipes/aggregate/clangdev-feedstock/recipe/build.sh
# llvmdev-feedstock/recipe/build.sh
# /home/papin_g/dev/github.com/AnacondaRecipes/aggregate/mysql-feedstock/recipe/build.sh (see LD handling)
# graphite2-feedstock/recipe/build.sh

# document why reset $libdir
# -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib

# include(FindPythonInterp)
# if( NOT PYTHONINTERP_FOUND )
#   message(FATAL_ERROR
# "Unable to find Python interpreter, required for builds and testing.

# Please install Python or specify the PYTHON_EXECUTABLE CMake variable.")
# endif()

# if( ${PYTHON_VERSION_STRING} VERSION_LESS 2.7 )
#   message(FATAL_ERROR "Python 2.7 or newer is required")
# endif()

# find_package(PythonInterp REQUIRED)

# XXX: necessary because Clang uses `include(FindPythonInterp)',
# instead of `find_package(PythonInterp)',
# and CMAKE_PREFIX_PATH is not honored by the former.
_cmake_config+=(
    -DPYTHON_EXECUTABLE=${CONDA_PREFIX}/bin/python
)

_cmake_config+=(
    -DGOLD_EXECUTABLE=${LD_GOLD}
)

# CMAKE_LIBRARY_PATH is wrong but it should be harmless
# as they do not actually use the value:
#
#     find_library(DL_LIBRARY_PATH dl)
#     if (DL_LIBRARY_PATH)
#       list(APPEND LIBS dl)
#     endif()
# It would probably be better to use CMAKE_DL_LIBS.

# document libxml2 used only for testing
# LLVM_ENABLE_LIBXML2=OFF

cmake -G Ninja \
      -DCMAKE_PREFIX_PATH=${CONDA_PREFIX} \
      -DCMAKE_C_COMPILER=${CC} \
      -DCMAKE_CXX_COMPILER=${CXX} \
      -DCMAKE_AR=${AR} \
      -DCMAKE_RANLIB=${RANLIB} \
      -DCMAKE_CXX_COMPILER_AR=${GCC_AR} \
      -DCMAKE_CXX_COMPILER_RANLIB=${GCC_RANLIB} \
      -DCMAKE_C_COMPILER_AR=${GCC_AR} \
      -DCMAKE_C_COMPILER_RANLIB=${GCC_RANLIB} \
      -DCMAKE_NM=${NM} \
      -DCMAKE_OBJCOPY=${OBJCOPY} \
      -DCMAKE_OBJDUMP=${OBJDUMP} \
      -DCMAKE_STRIP=${STRIP} \
      -DCMAKE_LINKER=${LD} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DLLVM_PARALLEL_LINK_JOBS=1 \
      -DLLVM_PARALLEL_COMPILE_JOBS=6 \
      -DLLVM_ENABLE_LIBXML2=OFF \
      ${_cmake_config[@]} \
      .. # /tmp/foopython            # ..

# grep -i have_terminfo CMakeCache.txt
