#!/bin/sh

WGET_OPTS=-nv
WORK_DIR=/tmp

BOOST_VER=1.70.0

pwd=$(pwd)

cd "${WORK_DIR}" || exit

wget ${WGET_OPTS} "https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VER}/source/boost_$(echo ${BOOST_VER} | tr . _).tar.gz" \
  && tar -xf "boost_$(echo ${BOOST_VER} | tr . _).tar.gz" \
  && rm "boost_$(echo ${BOOST_VER} | tr . _).tar.gz" \
  && cd "boost_$(echo ${BOOST_VER} | tr . _)" \
  && ./bootstrap.sh --prefix=/usr/local -with-toolset=gcc \
  && sudo ./b2 "-j$(nproc)" install cxxstd=14 boost.locale.posix=off boost.locale.icu=off link=static || \
    (printf "Error: boost build failed.\nBuild log:\n\n"; cat bootstrap.log; exit 1) \
  && rm -rf "${WORK_DIR}/boost_$(echo ${BOOST_VER} | tr . _)"

cd "$pwd" || exit
