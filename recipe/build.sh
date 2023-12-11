#!/bin/bash

set -e

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

# Apply hack for ldas-tools-al using a no-longer-defined function
patch -N -p0 -f -i $RECIPE_DIR/ldastoolsal-fstream-hack.patch -d $PREFIX

# build
make -j ${CPU_COUNT} VERBOSE=1 V=1

# test
# root is broken inside qemu, see https://github.com/conda-forge/gwollum-feedstock/pull/53#issuecomment-1849882209
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" && "${CROSSCOMPILING_EMULATOR}" == "" ]]; then
  make -j ${CPU_COUNT} VERBOSE=1 V=1 check
fi

# install
make -j ${CPU_COUNT} VERBOSE=1 V=1 install

# Revert hack for ldas-tools-al using a no-longer-defined function
patch -R -p0 -f -i $RECIPE_DIR/ldastoolsal-fstream-hack.patch -d $PREFIX
