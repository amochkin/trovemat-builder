#!/bin/sh

WGET_OPTS=-nv
WORK_DIR=/tmp

GCC_VER=8.3.0
MPC_VER=1.2.1
MPFR_VER=4.1.0

pwd=$(pwd)

cd "$WORK_DIR" || exit

### https://mirrors.kernel.org/gnu/

### https://mirrors.kernel.org/gnu/mpfr/mpfr-${MPFR_VER}.tar.gz

wget ${WGET_OPTS} "https://www.mpfr.org/mpfr-current/mpfr-${MPFR_VER}.tar.gz" \
  && tar -xf "mpfr-${MPFR_VER}.tar.gz" \
  && cd "mpfr-${MPFR_VER}" \
  && ./configure \
  && make "-j$(nproc)" \
  && sudo make install \
  && rm -rf "$WORK_DIR/mpfr-${MPFR_VER}" \
  || exit

cd "$WORK_DIR" || exit

### https://mirrors.kernel.org/gnu/mpc/mpc-${MPC_VER}.tar.gz

wget ${WGET_OPTS} "https://mirrors.kernel.org/gnu/mpc/mpc-${MPC_VER}.tar.gz" \
  && tar -xf "mpc-${MPC_VER}.tar.gz" \
  && cd "mpc-${MPC_VER}" \
  && ./configure \
  && make "-j$(nproc)" \
  && sudo make install \
  && rm -rf "$WORK_DIR/mpc-${MPC_VER}" \
  || exit

cd "$WORK_DIR" || exit

### https://mirrors.kernel.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.gz

wget ${WGET_OPTS} "https://mirrors.kernel.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.gz" \
  && tar -xf "gcc-${GCC_VER}.tar.gz" \
  && cd "gcc-${GCC_VER}" \
  && ./contrib/download_prerequisites \
  && mkdir -p "_build" \
  && cd "_build" \
  && ../configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --prefix=/usr/local/gcc-${GCC_VER} \
      --enable-checking=release --enable-languages=c,c++ --disable-multilib --with-system-zlib --program-suffix=-${GCC_VER} \
  && make "-j$(nproc)" \
  && sudo make install \
  && sudo update-alternatives --install /usr/bin/g++ g++ /usr/local/gcc-${GCC_VER}/bin/g++-${GCC_VER} 100 \
  && sudo update-alternatives --install /usr/bin/gcc gcc /usr/local/gcc-${GCC_VER}/bin/gcc-${GCC_VER} 100 \
  && rm -rf "$WORK_DIR/gcc-${GCC_VER}" "$WORK_DIR/gcc-${GCC_VER}-build" \
  || exit

cd "$pwd" || exit