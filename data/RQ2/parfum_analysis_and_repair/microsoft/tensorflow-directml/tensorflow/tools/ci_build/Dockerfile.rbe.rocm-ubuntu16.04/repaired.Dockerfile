# $ docker build -f Dockerfile.rbe.rocm-ubuntu16.04 \
#       --tag "gcr.io/tensorflow-testing/nosla-rocm-ubuntu16.04" .
# $ docker push gcr.io/tensorflow-testing/nosla-rocm-ubuntu16.04
FROM launcher.gcr.io/google/rbe-ubuntu16-04:latest
MAINTAINER Christian Sigg <csigg@google.com>

ARG DEB_ROCM_REPO=http://repo.radeon.com/rocm/apt/debian/
ARG ROCM_PATH=/opt/rocm

# Add rocm repository
RUN apt-get clean all
RUN wget -qO - $DEB_ROCM_REPO/rocm.gpg.key | apt-key add -
RUN sh -c  "echo deb [arch=amd64] $DEB_ROCM_REPO xenial main > /etc/apt/sources.list.d/rocm.list"

# Install rocm pkgs
RUN apt-get update --allow-insecure-repositories && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y --allow-unauthenticated \
    rocm-dev rocm-libs rocm-utils rocm-cmake \
    rocfft miopen-hip miopengemm rocblas hipblas rocrand rccl \
    rocm-profiler cxlactivitylogger && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV HCC_HOME=$ROCM_PATH/hcc
ENV HIP_PATH=$ROCM_PATH/hip
ENV OPENCL_ROOT=$ROCM_PATH/opencl
ENV PATH="$HCC_HOME/bin:$HIP_PATH/bin:${PATH}"
ENV PATH="$ROCM_PATH/bin:${PATH}"
ENV PATH="$OPENCL_ROOT/bin:${PATH}"

# Add target file to help determine which device(s) to build for
RUN bash -c 'echo -e "gfx803\ngfx900\ngfx906" >> /opt/rocm/bin/target.lst'

# Copy and run the install scripts.
COPY install/*.sh /install/
RUN /install/install_pip_packages_remote.sh
RUN /install/install_pip_packages.sh

