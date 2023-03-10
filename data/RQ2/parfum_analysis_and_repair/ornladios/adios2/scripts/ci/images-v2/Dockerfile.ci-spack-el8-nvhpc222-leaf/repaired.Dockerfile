ARG PARALLEL
FROM ornladios/adios2:ci-spack-el8-gcc8-${PARALLEL}

# Install NVHPC SDK
RUN cd /tmp && \
    curl -f -L -O https://developer.download.nvidia.com/hpc-sdk/22.2/nvhpc_2022_222_Linux_x86_64_cuda_11.6.tar.gz && \
    tar -xf nvhpc_2022_222_Linux_x86_64_cuda_11.6.tar.gz && \
    cd nvhpc_2022_222_Linux_x86_64_cuda_11.6 && \
    export \
      NVHPC_SILENT=true \
      NVHPC_INSTALL_DIR=/opt/nvidia/hpc_sdk \
      NVHPC_INSTALL_TYPE=single && \
    ./install && \
    echo 'export MODULEPATH=/opt/nvidia/hpc_sdk/modulefiles:${MODULEPATH}' > /etc/profile.d/nvhpc-modules.sh && \
    echo 'setenv MODULEPATH /opt/nvidia/hpc_sdk/modulefiles:${MODULEPATH}' > /etc/profile.d/nvhpc-modules.csh && rm nvhpc_2022_222_Linux_x86_64_cuda_11.6.tar.gz

# Purge the unneded parts of the install to reclaim some space
ARG PARALLEL
RUN rm -rf \
      /tmp/nvhpc* \
      /opt/nvidia/hpc_sdk/Linux_x86_64/2022 \
      /opt/nvidia/hpc_sdk/Linux_x86_64/22.2/math_libs \
      /opt/nvidia/hpc_sdk/Linux_x86_64/22.2/profilers \
      /opt/nvidia/hpc_sdk/Linux_x86_64/22.2/examples \
      /opt/nvidia/hpc_sdk/modulefiles/nvhpc-byo-compiler \
      /opt/nvidia/hpc_sdk/modulefiles/nvhpc-nompi && \
    sed -e '/nvmathdir/ d' -i /opt/nvidia/hpc_sdk/modulefiles/nvhpc/* && \
    dnf config-manager --add-repo \
      https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo && \
    dnf install -y nvidia-driver-cuda-libs && \
    if [ "${PARALLEL}" = "serial" ] ; \
    then \
      rm -rf /opt/nvidia/hpc_sdk/Linux_x86_64/22.2/comm_libs ; \
      sed -e '/nvcommdir/ d' -i /opt/nvidia/hpc_sdk/modulefiles/nvhpc/* ; \
    else \
      dnf install -y libatomic ; \
    fi && \
    dnf clean all
