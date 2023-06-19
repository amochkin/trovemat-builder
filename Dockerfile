FROM debian:10-slim as builder
MAINTAINER "Alexander Mochkin <https://github.com/amochkin>"

### Set build required env vars

ENV BUILD_DEPS="wget build-essential devscripts toilet p7zip-full ca-certificates"
ENV TOXCORE_DEPS="libsodium-dev pkg-config"
ENV TROVEMAT_DEPS="libusb-0.1-4 libusb-dev libpulse-dev libsqlite3-dev libgl1-mesa-dev zlib1g-dev"
ENV QT_DEPS="git"
ENV WGET_OPTS=-nv
ENV NPROC="nproc --ignore=4"

WORKDIR /deps

RUN printenv

### Install deps

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends ${BUILD_DEPS} ${TROVEMAT_DEPS} ${TOXCORE_DEPS} ${QT_DEPS}

### Compile GCC from source

ENV GCC_VER=8.3.0

### Refer to https://gcc.gnu.org/install/configure.html for configuration options.

RUN wget ${WGET_OPTS} ftp://ftp.lip6.fr/pub/gcc/releases/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.xz \
    && tar -xf gcc-${GCC_VER}.tar.xz && rm gcc-${GCC_VER}.tar.xz && cd gcc-${GCC_VER} \
    && ./contrib/download_prerequisites && cd .. \
    && mkdir -p gcc-${GCC_VER}-build && cd gcc-${GCC_VER}-build \
    && ../gcc-${GCC_VER}/configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu \
      --target=x86_64-linux-gnu  \
      --prefix=/usr/local/gcc-8.3 \
      --with-bugurl="https://github.com/bytewerk/trovemat-builder" \
      --enable-checking=release \
      --enable-languages=c,c++ \
      --enable-host-shared \
      --disable-multilib \
      --with-system-zlib \
      --program-suffix=-8.3 \
    && make -j$($NPROC) \
    && make install \
    && rm -rf /deps/*

RUN update-alternatives --install /usr/bin/g++ g++ /usr/local/gcc-8.3/bin/g++-8.3 100 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/local/gcc-8.3/bin/gcc-8.3 100

### Compile OpenSSL from source
### https://github.com/openssl/openssl

ENV SSL_VER=1.1.1u

RUN wget ${WGET_OPTS} https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_$(echo ${SSL_VER} | tr . _).tar.gz \
    && tar -xf OpenSSL_$(echo ${SSL_VER} | tr . _).tar.gz  \
    && rm OpenSSL_$(echo ${SSL_VER} | tr . _).tar.gz \
    && cd openssl-OpenSSL_$(echo ${SSL_VER} | tr . _) \
    && ./config --prefix=/usr/local --openssldir=/usr/local -ldl \
    && make -j$($NPROC) \
    && make install \
    && rm -rf /deps/*

### Compile Cmake from source
### https://github.com/Kitware/CMake

ENV CMAKE_VER=3.23.1

RUN wget ${WGET_OPTS} https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz \
    && tar -xf cmake-${CMAKE_VER}.tar.gz \
    && rm cmake-${CMAKE_VER}.tar.gz \
    && cd cmake-${CMAKE_VER} && ./bootstrap \
    && make -j$($NPROC) \
    && make install \
    && rm -rf /deps/*

### Compile Boost from source

ENV BOOST_VER=1.70.0

RUN wget ${WGET_OPTS} https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VER}/source/boost_$(echo $BOOST_VER | tr . _).tar.gz  \
    && tar -xf boost_$(echo $BOOST_VER | tr . _).tar.gz \
    && rm boost_$(echo $BOOST_VER | tr . _).tar.gz \
    && cd boost_$(echo $BOOST_VER | tr . _) \
    && ./bootstrap.sh --prefix=/usr/local -with-toolset=gcc \
    && (./b2 -j$($NPROC) install cxxstd=14 boost.locale.posix=off boost.locale.icu=off link=static \
    || (printf "Error: boost build failed.\nBuild log:\n\n"; cat bootstrap.log; exit 1)) \
    && rm -rf /deps/*

### Compile Toxcore from source
### https://github.com/TokTok/c-toxcore

ENV TOXCORE_VER=0.2.18

RUN wget ${WGET_OPTS} https://github.com/TokTok/c-toxcore/releases/download/v${TOXCORE_VER}/c-toxcore-${TOXCORE_VER}.tar.gz  \
    && tar -xf c-toxcore-${TOXCORE_VER}.tar.gz \
    && rm c-toxcore-${TOXCORE_VER}.tar.gz \
    && cd c-toxcore-${TOXCORE_VER} \
    && mkdir -p _build \
    && cd _build \
    && cmake .. \
    && make -j$($NPROC) \
    && make install \
    && rm -rf /deps/*

### Compile Qt from source

ENV QT_VER=5.15.2

RUN git clone https://github.com/qt/qt5.git --branch="${QT_VER}" --depth=1 "qt" \
    && cd qt \
    && git submodule update --init --recursive --depth=1 \
    && ./configure -opensource -release -confirm-license \
      -nomake examples -nomake tests -skip qtdocgallery \
    && make -j$($NPROC) \
    && make install \
    && rm -rf /deps/*

WORKDIR /builder