ARG COMPILER_IMG_BASE
FROM ornladios/adios2:ci-spack-el8-${COMPILER_IMG_BASE}-base

ARG EXTRA_VARIANTS
RUN sed "s|variants: +blosc|variants: ${EXTRA_VARIANTS} +blosc|" \
      -i /etc/spack/packages.yaml && \
    sed "s|variants: api=|variants: ${EXTRA_VARIANTS} api=|" \
      -i /etc/spack/packages.yaml

# Build dependencies
ARG COMPILER_SPACK_ID
RUN . /etc/profile.d/modules.sh && \
    . /opt/spack/share/spack/setup-env.sh && \
    spack install \
      --fail-fast \
      -v \
      -j$(grep -c '^processor' /proc/cpuinfo) \
      libsodium%${COMPILER_SPACK_ID} && \
    spack install \
      --fail-fast \
      -v \
      -j$(grep -c '^processor' /proc/cpuinfo) \
      --only dependencies \
      adios2%${COMPILER_SPACK_ID} ^rhash%gcc && \
    spack clean -a

# Setup modules
RUN . /opt/spack/share/spack/setup-env.sh && \
    spack env create --without-view adios2-ci && \
    spack -e adios2-ci add $(spack find --format "/{hash}") && \
    spack -e adios2-ci install && \
    rm -rf /root/.spack && \
    spack env activate adios2-ci && \
    spack env deactivate && \
    spack -e adios2-ci env loads

# Setup default login environment
RUN echo 'source /opt/spack/share/spack/setup-env.sh' > /etc/profile.d/zz-adios2-ci-env.sh && \
    echo 'module use ${SPACK_ROOT}/share/spack/modules/linux-almalinux8-haswell' >> /etc/profile.d/zz-adios2-ci-env.sh && \
    echo 'source ${SPACK_ROOT}/var/spack/environments/adios2-ci/loads' >> /etc/profile.d/zz-adios2-ci-env.sh