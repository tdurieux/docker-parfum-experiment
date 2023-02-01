# FROM must be called before other ARGS except for ARG BASE_IMAGE
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# For bash-specific commands
SHELL ["/bin/bash", "-c"]

# Required build args, should be specified in docker_build.sh
ARG DEVELOPER_BUILD
ARG CCACHE_TAR_NAME
ARG CMAKE_VERSION
ARG CCACHE_VERSION
ARG PYTHON_VERSION
ARG BUILD_SHARED_LIBS
ARG BUILD_CUDA_MODULE
ARG BUILD_TENSORFLOW_OPS
ARG BUILD_PYTORCH_OPS
ARG PACKAGE
ARG BUILD_SYCL_MODULE

RUN if [ -z "${DEVELOPER_BUILD}"      ]; then echo "Error: ARG DEVELOPER_BUILD      not specified."; exit 1; fi \
 && if [ -z "${CCACHE_TAR_NAME}"      ]; then echo "Error: ARG CCACHE_TAR_NAME      not specified."; exit 1; fi \
 && if [ -z "${CMAKE_VERSION}"        ]; then echo "Error: ARG CMAKE_VERSION        not specified."; exit 1; fi \
 && if [ -z "${CCACHE_VERSION}"       ]; then echo "Error: ARG CCACHE_VERSION       not specified."; exit 1; fi \
 && if [ -z "${PYTHON_VERSION}"       ]; then echo "Error: ARG PYTHON_VERSION       not specified."; exit 1; fi \
 && if [ -z "${BUILD_SHARED_LIBS}"               ]; then echo "Error: ARG BUILD_SHARED_LIBS               not specified."; exit 1; fi \
 && if [ -z "${BUILD_CUDA_MODULE}"    ]; then echo "Error: ARG BUILD_CUDA_MODULE    not specified."; exit 1; fi \
 && if [ -z "${BUILD_TENSORFLOW_OPS}" ]; then echo "Error: ARG BUILD_TENSORFLOW_OPS not specified."; exit 1; fi \
 && if [ -z "${BUILD_PYTORCH_OPS}"    ]; then echo "Error: ARG BUILD_PYTORCH_OPS    not specified."; exit 1; fi \
 && if [ -z "${PACKAGE}"              ]; then echo "Error: ARG PACKAGE              not specified."; exit 1; fi \
 && if [ -z "${BUILD_SYCL_MODULE}"    ]; then echo "Error: ARG BUILD_SYCL_MODULE    not specified."; exit 1; fi

# Fix Nvidia repo key rotation issue
# https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212771
# https://forums.developer.nvidia.com/t/18-04-cuda-docker-image-is-broken/212892/10
# https://code.visualstudio.com/remote/advancedcontainers/reduce-docker-warnings#:~:text=Warning%3A%20apt%2Dkey%20output%20should,not%20running%20from%20a%20terminal.
RUN if [ "${BUILD_CUDA_MODULE}" = "ON" ]; then \
        export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn; \
        apt-key del 7fa2af80; \
        apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub; \
        apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub; \
    fi

# Forward all ARG to ENV
# ci_utils.sh may require these environment variables
ENV DEVELOPER_BUILD=${DEVELOPER_BUILD}
ENV CCACHE_TAR_NAME=${CCACHE_TAR_NAME}
ENV CMAKE_VERSION=${CMAKE_VERSION}
ENV CCACHE_VERSION=${CCACHE_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}
ENV BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
ENV BUILD_CUDA_MODULE=${BUILD_CUDA_MODULE}
ENV BUILD_TENSORFLOW_OPS=${BUILD_TENSORFLOW_OPS}
ENV BUILD_PYTORCH_OPS=${BUILD_PYTORCH_OPS}
ENV PACKAGE=${PACKAGE}
ENV BUILD_SYCL_MODULE=${BUILD_SYCL_MODULE}

# Prevent interactive inputs when installing packages
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
ENV SUDO=command

# The base image already contains the oneAPI packages.
# Having this in the list can cause checksum errors when apt-get update.
RUN if [ "${BUILD_SYCL_MODULE}" = "ON" ]; then \
        rm -rf /etc/apt/sources.list.d/oneAPI.list; \
    fi

# Dependencies: basic
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    wget \
    curl \
    build-essential \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

# Miniconda or Intel conda
# The **/open3d/bin paths are used during docker run, in this way docker run
# does not need to activate the environment again.
ENV PATH="/root/miniconda3/bin:${PATH}"
ENV PATH="/root/miniconda3/envs/open3d/bin:${PATH}"
ENV PATH="/opt/intel/oneapi/intelpython/latest/bin:${PATH}"
ENV PATH="/opt/intel/oneapi/intelpython/latest/envs/open3d/bin:${PATH}"
RUN if [ "${BUILD_SYCL_MODULE}" = "OFF" ]; then \
        wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh; \
        bash Miniconda3-latest-Linux-x86_64.sh -b; \
        rm Miniconda3-latest-Linux-x86_64.sh; \
    fi
RUN conda --version \
 && conda create -y -n open3d python=${PYTHON_VERSION}

# Activate open3d virtualenv
# This works during docker build. It becomes the prefix of all RUN commands.
# Ref: https://stackoverflow.com/a/60148365/1255535
SHELL ["conda", "run", "-n", "open3d", "/bin/bash", "-c"]

# Dependencies: cmake
ENV PATH=${HOME}/${CMAKE_VERSION}/bin:${PATH}
RUN CMAKE_VERSION_NUMBERS=$(echo "${CMAKE_VERSION}" | cut -d"-" -f2) \
 && wget -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION_NUMBERS}/${CMAKE_VERSION}.tar.gz \
 && tar -xf ${CMAKE_VERSION}.tar.gz \
 && cp -ar ${CMAKE_VERSION} ${HOME} \
 && cmake --version && rm ${CMAKE_VERSION}.tar.gz

# Dependencies: ccache
WORKDIR /root
RUN git clone https://github.com/ccache/ccache.git \
 && cd ccache \
 && git checkout v${CCACHE_VERSION} -b ${CCACHE_VERSION} \
 && mkdir build \
 && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release -DZSTD_FROM_INTERNET=ON .. \
 && make install -j$(nproc) \
 && which ccache \
 && ccache --version \
 && ccache -s

# Download ccache from GCS bucket
# If it doesn't exist on the cloud, an empty ${CCACHE_DIR} will be created.
# Example directory structure:
# - CCACHE_DIR        = ~/.cache/ccache
# - CCACHE_DIR_NAME   = ccache
# - CCACHE_DIR_PARENT = ~/.cache
# We need to set ccache size explicitly with -M, otherwise the defualt size is
# *not* determined by ccache's default, but the downloaded ccache file's config.
RUN CCACHE_DIR=$(ccache -p | grep cache_dir | grep -oE "[^ ]+$") \
 && CCACHE_DIR_NAME=$(basename ${CCACHE_DIR}) \
 && CCACHE_DIR_PARENT=$(dirname ${CCACHE_DIR}) \
 && mkdir -p ${CCACHE_DIR_PARENT} \
 && cd ${CCACHE_DIR_PARENT} \
 && (wget -q https://storage.googleapis.com/open3d-ci-cache/${CCACHE_TAR_NAME}.tar.gz || true) \
 && if [ -f ${CCACHE_TAR_NAME}.tar.gz ]; then \
 tar -xf ${CCACHE_TAR_NAME}.tar.gz; rm ${CCACHE_TAR_NAME}.tar.gz fi \
 && mkdir -p ${CCACHE_DIR} \
 && ccache -M 5G \
 && ccache -s

# Checkout Open3D-ML master branch
# TODO: We may add support for local Open3D-ML repo or pinned ML repo tag
ENV OPEN3D_ML_ROOT=/root/Open3D-ML
RUN git clone --depth 1 https://github.com/isl-org/Open3D-ML.git ${OPEN3D_ML_ROOT}

# Open3D repo
# Always keep /root/Open3D as the WORKDIR
COPY . /root/Open3D
WORKDIR /root/Open3D

# Open3D C++ dependencies
RUN ./util/install_deps_ubuntu.sh assume-yes \
 && rm -rf /var/lib/apt/lists/*

# Open3D Python dependencies
RUN source util/ci_utils.sh \
 && if [ "${BUILD_CUDA_MODULE}" = "ON" ]; then \
        install_python_dependencies with-cuda with-jupyter; \
    else \
        install_python_dependencies with-jupyter; \
    fi \
 && pip install --no-cache-dir -r python/requirements_test.txt

# Open3D Jupyter dependencies
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install --no-install-recommends -y nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && node --version \
 && npm install -g yarn \
 && yarn --version && npm cache clean --force; && yarn cache clean;

# Build all
RUN if [ "${BUILD_PYTORCH_OPS}" = "ON" ] || [ "${BUILD_TENSORFLOW_OPS}" = "ON" ]; then \
        export GLIBCXX_USE_CXX11_ABI=OFF; \
    else \
        export GLIBCXX_USE_CXX11_ABI=ON; \
    fi \
 && if [ "${BUILD_SYCL_MODULE}" = "ON" ]; then \
        export CMAKE_CXX_COMPILER=icpx; \
        export CMAKE_C_COMPILER=icx; \
    else \
        export CMAKE_CXX_COMPILER=g++; \
        export CMAKE_C_COMPILER=gcc; \
    fi \
 && mkdir build \
 && cd build \
 && cmake -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS} \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} \
          -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} \
          -DBUILD_SYCL_MODULE=${BUILD_SYCL_MODULE} \
          -DDEVELOPER_BUILD=${DEVELOPER_BUILD} \
          -DBUILD_LIBREALSENSE=ON \
          -DBUILD_CUDA_MODULE=${BUILD_CUDA_MODULE} \
          -DBUILD_COMMON_CUDA_ARCHS=ON \
          -DBUILD_COMMON_ISPC_ISAS=ON \
          -DGLIBCXX_USE_CXX11_ABI=${GLIBCXX_USE_CXX11_ABI} \
          -DBUILD_TENSORFLOW_OPS=${BUILD_TENSORFLOW_OPS} \
          -DBUILD_PYTORCH_OPS=${BUILD_PYTORCH_OPS} \
          -DBUILD_UNIT_TESTS=ON \
          -DBUILD_BENCHMARKS=ON \
          -DBUILD_EXAMPLES=ON \
          -DCMAKE_INSTALL_PREFIX=~/open3d_install \
          .. \
 && make VERBOSE=1 -j$(nproc) \
 && make install-pip-package -j$(nproc) \
 && make install -j$(nproc) \
 && if [ "${PACKAGE}" = "ON" ]; then make package; fi

# Compress ccache folder, move to / directory
RUN ccache -s \
 && CCACHE_DIR=$(ccache -p | grep cache_dir | grep -oE "[^ ]+$") \
 && CCACHE_DIR_NAME=$(basename ${CCACHE_DIR}) \
 && CCACHE_DIR_PARENT=$(dirname ${CCACHE_DIR}) \
 && cd ${CCACHE_DIR_PARENT} \
 && tar -czf /${CCACHE_TAR_NAME}.tar.gz ${CCACHE_DIR_NAME} \
 && if [ "${PACKAGE}" = "ON" ]; then mv /root/Open3D/build/package/open3d-devel*.tar.xz /; fi \
 && ls -alh / && rm /${CCACHE_TAR_NAME}.tar.gz

RUN echo "Docker build done."
