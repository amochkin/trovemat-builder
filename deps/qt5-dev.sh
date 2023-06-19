#!/bin/sh

### Required packages: xcb-xfixes
### sudo apt install libxcb-xfixes0-dev

WORK_DIR=/tmp
CPU_THREADS=$(nproc)

QT_VER=5.15.2

pwd=$(pwd)
umask=$(umask)

cd "$WORK_DIR" || exit
umask 000

cmd=$(cat << EOF
git clone https://code.qt.io/qt/qt5.git --branch="${QT_VER}" --depth=1 "qt-${QT_VER}" \
  && cd "qt-${QT_VER}" \
  && perl init-repository \
  && mkdir -p _build \
  && cd _build \
  && ../configure -opensource -release -confirm-license -developer-build \
      -nomake examples -nomake tests -skip qtdocgallery \
      -platform linux-g++ -prefix /opt/qt-${QT_VER} \
  && make -j${CPU_THREADS} \
  && sudo make install \
  && rm -rf "$WORK_DIR/qt-${QT_VER}"
EOF
)

echo "$cmd"

umask "$umask"
cd "$pwd" || exit
