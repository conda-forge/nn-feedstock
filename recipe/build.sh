#!/bin/bash

pushd nn

# The bundled triangle.c uses K&R declarations by default, which are errors
# under C23 (GCC 15 default). Upstream adds this flag in nn-c v2.0.11, so it
# can be removed once the recipe is updated to v2.0.11 or later.
export CFLAGS="${CFLAGS} -DANSI_DECLARATORS"

# The exact arithmetic of the robust geometric predicates in the bundled
# triangle.c requires each floating-point operation to be rounded separately.
# GCC contracts a*b+c into fused multiply-add instructions by default on
# targets that have them (e.g. aarch64, ppc64le), which breaks the predicates
# and makes the Delaunay triangulation hang.
export CFLAGS="${CFLAGS} -ffp-contract=off"

./configure --prefix=$PREFIX
make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make tests
fi
make install

popd
