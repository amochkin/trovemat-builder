#!/bin/sh

WGET_OPTS="-nv"
OTI_VER=0.1.0
WORK_DIR=/tmp

pwd=$(pwd)

cd "$WORK_DIR" || exit

wget ${WGET_OPTS} -O liboti-${OTI_VER}.tar.gz https://codeload.github.com/librexfs/liboti/tar.gz/refs/tags/v${OTI_VER} \
  && tar -xf liboti-${OTI_VER}.tar.gz \
  && cd liboti-${OTI_VER} \
  && mkdir -p _build \
  && cd _build \
  && cmake .. \
  && make clean \
  && make "-j$(nproc)" \
  && sudo make install \
  && rm -rf "$WORK_DIR/liboti-${OTI_VER}"

cd "$pwd" || exit
