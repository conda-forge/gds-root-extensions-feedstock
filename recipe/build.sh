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
patch -f -i $RECIPE_DIR/ldastoolsal-fstream-hack.patch -d $PREFIX

# build
make -j ${CPU_COUNT} VERBOSE=1 V=1

# test
make -j ${CPU_COUNT} VERBOSE=1 V=1 check

# install
make -j ${CPU_COUNT} VERBOSE=1 V=1 install

# Revert hack for ldas-tools-al using a no-longer-defined function
patch -R -f -i $RECIPE_DIR/ldastoolsal-fstream-hack.patch -d $PREFIX
