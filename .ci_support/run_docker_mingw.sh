#!/bin/sh

set -xe

git clone --depth 1 https://git.salome-platform.org/gitpub/tools/configuration.git /tmp/configuration

cd /tmp/configuration
mkdir build && cd build

ARCH=x86_64
MINGW_PREFIX=/usr/${ARCH}-w64-mingw32
PYMAJMIN=310
PREFIX=${PWD}/install
CXXFLAGS="-Wall -Wextra -Werror -D_GLIBCXX_ASSERTIONS" ${ARCH}-w64-mingw32-cmake \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
  -DPython_INCLUDE_DIR=${MINGW_PREFIX}/include/python${PYMAJMIN} \
  -DPython_LIBRARY=${MINGW_PREFIX}/lib/libpython${PYMAJMIN}.dll.a \
  -DPython_EXECUTABLE=/usr/bin/${ARCH}-w64-mingw32-python${PYMAJMIN}-bin \
  -DCONFIGURATION_ROOT_DIR=/tmp/configuration \
  /io
make install
