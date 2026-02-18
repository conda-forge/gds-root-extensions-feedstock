#!/bin/bash

set -e

# update config.sub/config.guess for arm64-apple-darwin support
if [ -d "${BUILD_PREFIX}/share/gnuconfig" ]; then
  cp ${BUILD_PREFIX}/share/gnuconfig/config.* ${SRC_DIR}/config/
fi

mkdir -p _build
cd _build

# configure
${SRC_DIR}/configure \
	--disable-static \
	--enable-dtt \
	--enable-online \
	--enable-shared \
	--includedir=${PREFIX}/include/gds \
	--prefix=${PREFIX} \
;

# build
make -j ${CPU_COUNT} VERBOSE=1 V=1

# test
# root is broken inside qemu, see https://github.com/conda-forge/gwollum-feedstock/pull/53#issuecomment-1849882209
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" && "${CROSSCOMPILING_EMULATOR}" == "" ]]; then
  make -j ${CPU_COUNT} VERBOSE=1 V=1 check
fi

# install
make -j ${CPU_COUNT} VERBOSE=1 V=1 install
