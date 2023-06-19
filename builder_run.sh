#!/bin/bash

docker run -ti \
  -v "$(pwd)/..":/builder/trovemat \
  -e GIT_COMMIT="$(git rev-parse HEAD)" \
  -e BRANCH="$(git rev-parse --abbrev-ref HEAD)" \
  -e DEMO=false \
  -e SERVER=true \
  -e NAME=preview_1804 \
  -e WORKSPACE=/builder/workspace \
  -e BUILD_NUMBER=1 \
  -e GIT_PREVIOUS_COMMIT=77ff187912f1b7df05187cbdb3f342653b39874b \
  -e WITH_UNIT_TESTS=false \
  jetcrypto/trovemat-builder \
  /bin/bash

