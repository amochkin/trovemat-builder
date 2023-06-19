#!/bin/sh

### Required packages: sodium
### sudo apt install libsodium-dev

WGET_OPTS=-nv
WORK_DIR=/tmp

TOXCORE_VER=0.2.18

pwd=$(pwd)

cd "$WORK_DIR" || exit

wget ${WGET_OPTS} https://github.com/TokTok/c-toxcore/releases/download/v${TOXCORE_VER}/c-toxcore-${TOXCORE_VER}.tar.gz \
  && tar -xf c-toxcore-${TOXCORE_VER}.tar.gz \
  && cd c-toxcore-${TOXCORE_VER} \
  && mkdir -p _build \
  && cd _build \
  && cmake .. \
  && make "-j$(nproc)" \
  && sudo make install \
  && rm -rf "$WORK_DIR/c-toxcore-${TOXCORE_VER}"

cd "$pwd" || exit