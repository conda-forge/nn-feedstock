#!/bin/bash

pushd nn

# The bundled triangle.c uses K&R declarations by default, which are errors
# under C23 (GCC 15 default). Upstream adds this flag in nn-c v2.0.11, so it
# can be removed once the recipe is updated to v2.0.11 or later.
export CFLAGS="${CFLAGS} -DANSI_DECLARATORS"

./configure --prefix=$PREFIX
make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make tests
fi
make install

popd
