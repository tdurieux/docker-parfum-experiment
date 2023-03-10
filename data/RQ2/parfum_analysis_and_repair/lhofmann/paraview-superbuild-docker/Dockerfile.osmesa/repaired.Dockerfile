ARG IMAGE_NAME
FROM ${IMAGE_NAME} as base

FROM base as builder

COPY scripts/build_paraview.osmesa.sh /home/paraview/build_paraview.osmesa.sh
RUN scl enable devtoolset-${DEVTOOLSET_VERSION} -- sh /home/paraview/build_paraview.osmesa.sh
RUN scl enable devtoolset-${DEVTOOLSET_VERSION} -- make -j1
RUN scl enable devtoolset-${DEVTOOLSET_VERSION} -- make install

FROM base as default
COPY --from=builder /home/paraview/buildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuild/install /home/paraview/buildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuild/install
ENV CMAKE_PREFIX_PATH=/home/paraview/buildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuildbuild/install

# required for ospray to find TBB
ENV TBB_ROOT=${CMAKE_PREFIX_PATH}

FROM default as package
COPY --from=builder /home/paraview/package /home/paraview/package

FROM default