#!/bin/bash

pushd nn

./configure --prefix=$PREFIX
make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make tests
fi
make install

popd
