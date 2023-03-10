#--------------------------------------------------------------------
# [ARGS] Arguments for FROM statements
#--------------------------------------------------------------------
ARG ubuntu_ver=20.04
#--------------------------------------------------------------------
# [BUILD-COMMON] Common build tools
#--------------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as common_build_tools
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    python3-pip python3-dev wget git build-essential cmake curl && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

#install dpc++ compiler
RUN unset DEBIAN_FRONTEND && \
    apt-get install --no-install-recommends -y curl software-properties-common && \
    curl -fsSL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB \
    | apt-key add - && \
    echo "deb https://apt.repos.intel.com/oneapi all main" \
    | tee /etc/apt/sources.list.d/oneAPI.list && \
    add-apt-repository -y "deb https://apt.repos.intel.com/oneapi all main" && \
    apt-get update && \
    apt-get install --no-install-recommends -y intel-oneapi-dpcpp-cpp-compiler && rm -rf /var/lib/apt/lists/*;

#export compiler paths
ENV COMPILER_DIR=/opt/intel/oneapi/compiler/2021.1.1/linux
ENV LD_LIBRARY_PATH=$COMPILER_DIR/lib:$COMPILER_DIR/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
WORKDIR /buildir
COPY scripts/ patches/ .

#--------------------------------------------------------------------
# [TF BUILDER] Builder Stage - Tensorflow on Ubuntu
#--------------------------------------------------------------------
FROM common_build_tools as tf_builder
LABEL maintainer=otc-swstacks@intel.com
ARG tf_ver
ARG platform

# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install --no-install-recommends --no-install-suggests \
    bc libjemalloc-dev \
    pkg-config zip zlib1g-dev unzip \
    golang-go && rm -rf /var/lib/apt/lists/*;



RUN pip install --no-cache-dir enum34

# Install Bazel
RUN go get github.com/bazelbuild/bazelisk \
    && export PATH=$PATH:~/go/bin/ \
    && ln -s ~/go/bin/bazelisk /usr/bin/bazel

RUN ./install_${tf_ver}_ubuntu.sh ${platform}


#--------------------------------------------------------------
# [TF CORE] DLRS Ubuntu TF Core
#--------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as tf_core

RUN apt-get update \
    && apt-get -y install --no-install-recommends --no-install-suggests \
    python3-pip python3 libgoogle-perftools4 libjemalloc2 libjemalloc-dev \
    && ln -s /usr/bin/python3.8 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoclean -y

COPY --from=tf_builder /tmp/tf/ /tmp/tf/

# install tensorflow
RUN pip --no-cache-dir install /tmp/tf/avx512/tensorflow*.whl \
    && rm -rf /tmp/tf

WORKDIR /workspace
COPY ./licenses/ /workspace/licenses
HEALTHCHECK --interval=5m --timeout=3s \
  CMD python -c "import sys" || exit 1
SHELL ["/bin/bash",  "-c"]

#--------------------------------------------------------------
# [FULL] Base DLRS Ubuntu TF
#--------------------------------------------------------------
FROM tf_core as tf_full_base
LABEL maintainer=otc-swstacks@intel.com
ARG tf_ver

# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends --no-install-suggests \
    libomp5 openmpi-bin libopenmpi-dev openssh-server \
    numactl zlib1g-dev libjpeg-dev && rm -rf /var/lib/apt/lists/*

# Create missing links
RUN ln -s /usr/lib/llvm-10/lib/libomp.so.5 /usr/lib/libiomp5.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libtcmalloc.so.4 /usr/lib/libtcmalloc.so

COPY common/ scripts/ .



# Install runtime deps, python pkgs and addons
WORKDIR /workspace
RUN apt-get update \
    && apt-get -y install --no-install-recommends --no-install-suggests \
    gcc g++ git python3-dev make curl cmake \
    && HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_MPI=1 pip --no-cache-dir install horovod==0.21.* \
    && ./install_py_packages.sh ${tf_ver} \
    && find /usr/lib/ -follow -type f -name '*.pyc' -delete \
    && find /usr/lib/ -follow -type f -name '*.js.map' -delete \
    && ./cleanup.sh \
    && rm -rf /workspace/* \
    && rm -rf /var/lib/apt/lists/*

# speech to text using deepspeech
RUN apt-get update && \
    apt-get install --no-install-recommends -y sox && \
    pip install --no-cache-dir deepspeech==0.9.3 && \
    rm -rf /var/lib/apt/lists/*


# copy license
COPY ./licenses /workspace/licenses
#--------------------------------------------------------------
# [FULL] DLRS Ubuntu TF
#--------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as tf_full
LABEL maintainer=otc-swstacks@intel.com

COPY --from=tf_full_base / /
SHELL ["/bin/bash",  "-c"]
