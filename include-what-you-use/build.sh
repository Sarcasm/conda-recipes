#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

# -p is useful when building with --dirty
mkdir -pv build
pushd build

# CMake options that could be used for any other projects
_cmake_config_defaults=(
    # toolchain variables, which we expect conda to have exported
    -DCMAKE_C_COMPILER="${CC}"
    -DCMAKE_CXX_COMPILER="${CXX}"
    -DCMAKE_AR="${AR}"
    -DCMAKE_RANLIB="${RANLIB}"
    -DCMAKE_CXX_COMPILER_AR="${GCC_AR}"
    -DCMAKE_CXX_COMPILER_RANLIB="${GCC_RANLIB}"
    -DCMAKE_C_COMPILER_AR="${GCC_AR}"
    -DCMAKE_C_COMPILER_RANLIB="${GCC_RANLIB}"
    -DCMAKE_NM="${NM}"
    -DCMAKE_OBJCOPY="${OBJCOPY}"
    -DCMAKE_OBJDUMP="${OBJDUMP}"
    -DCMAKE_STRIP="${STRIP}"
    -DCMAKE_LINKER="${LD}"

    # It's not pretty,
    # but CFLAGS and CXXFLAGS contains variables that needs to be expanded,
    # and without this the CMake/Ninja combo does not expand them correctly.
    # CFLAGS/CXXFLAGS have:
    #    -fdebug-prefix-map=${SRC_DIR}=/usr/local/src/conda/${PKG_NAME}-${PKG_VERSION}
    #    -fdebug-prefix-map=${PREFIX}=/usr/local/src/conda-prefix
    # which expands to:
    #    -fdebug-prefix-map==/usr/local/src/conda/-
    #    -fdebug-prefix-map==/usr/local/src/conda-prefix
    -DCMAKE_C_FLAGS="$(eval echo ${CFLAGS})"
    -DCMAKE_CXX_FLAGS="$(eval echo ${CXXFLAGS})"

    # other standard variables
    # PREFIX: 'host' requirements prefix, e.g. libncurses needed for build
    # CONDA_PREFIX: 'build' requirements prefix, e.g. python needed for build
    # not specified, because CMake is installed there, so it's in its default paths
    # BUILD_PREFIX: same as PREFIX?
    -DCMAKE_PREFIX_PATH="${PREFIX}"
    -DCMAKE_INSTALL_PREFIX="${PREFIX}"
    -DCMAKE_BUILD_TYPE=Release

    # disabled because conda removes it and replaces it with patchelf
    -DCMAKE_SKIP_INSTALL_RPATH=OFF

    # these, I'm not sure, could vary between projects?
    # or at least would benefit from
    # being overridable by conda_build_config.yaml
    -DBUILD_SHARED_LIBS=OFF
)

env

cmake -G Ninja "${_cmake_config_defaults[@]}" ..

ninja ${VERBOSE_NINJA--v} install

readelf -d ${PREFIX}/bin/include-what-you-use | head -20