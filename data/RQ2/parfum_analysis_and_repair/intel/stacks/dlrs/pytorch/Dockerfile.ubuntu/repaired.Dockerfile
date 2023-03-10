#--------------------------------------------------------------------
# Build Pytorch & Torchvision Wheels on Centos
#--------------------------------------------------------------------
ARG ubuntu_ver=20.04
FROM ubuntu:$ubuntu_ver as wheel-builder
LABEL maintainer=otc-swstacks@intel.com

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
    && apt-get -y upgrade \
    && apt-get -y --no-install-recommends install wget libjemalloc-dev git gcc g++ python3-pip && rm -rf /var/lib/apt/lists/*;

#Install DPC++ Compiler
RUN apt-get install --no-install-recommends -y curl software-properties-common && \
    update-ca-certificates --fresh \
    && curl -f -k https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB \
    | apt-key add - && \
    echo "deb https://apt.repos.intel.com/oneapi all main" \
    | tee /etc/apt/sources.list.d/oneAPI.list && \
    add-apt-repository -y "deb https://apt.repos.intel.com/oneapi all main" && \
    apt-get update && \
    apt-get install --no-install-recommends -y intel-oneapi-dpcpp-cpp-compiler && rm -rf /var/lib/apt/lists/*;

#export compiler paths
ENV COMPILER_DIR=/opt/intel/oneapi/compiler/2021.1.1/linux
ENV LD_LIBRARY_PATH=$COMPILER_DIR/lib:$COMPILER_DIR/compiler/lib/intel64_lin

RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && rm -rf /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR buildir
COPY scripts/torch_utils.sh common/requirements.txt dataloader.patch_v1.8.0-rc2 .
RUN pip --no-cache-dir install -r requirements.txt wheel \
    && ./torch_utils.sh

RUN cd /buildir/pytorch \
    && python setup.py bdist_wheel -d /torch-wheels && python setup.py install

RUN cd /buildir/vision \
    && python setup.py bdist_wheel -d /torch-wheels

#--------------------------------------------------------------------
# [CORE] Pytorch & Torchvision CPU on Ubuntu
#--------------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as ubuntu-core
LABEL maintainer=otc-swstacks@intel.com

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y --no-install-recommends install --no-install-suggests \
       python3-pip python3 \
    && ln -s /usr/bin/python3.8 /usr/bin/python \
    && rm -rf /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip \
    && apt-get autoclean -y && rm -rf /var/lib/apt/lists/*;

COPY --from=wheel-builder /torch-wheels /torch-wheels
RUN pip --no-cache-dir install torch-wheels/* \
    && rm -rf /torch-wheels

WORKDIR workspace
COPY scripts/generate_defaults.py common/requirements.txt .
RUN pip --no-cache-dir install intel-openmp \
    && pip --no-cache-dir install --no-deps \
    -r requirements.txt \
    && rm -rf ./requirements.txt

RUN python generate_defaults.py --generate \
    && cat mkl_env.sh >> /etc/bash.bashrc \
    && rm -rf /workspace/* \
    && chmod -R a+w /workspace

COPY ./licenses/ /workspace/licenses

SHELL ["/bin/bash",  "-c"]

#--------------------------------------------------------------------
# [FULL] Base Frameworks and Add-ons CPU on Ubuntu
#--------------------------------------------------------------------
FROM ubuntu-core as ubuntu-full-base
LABEL maintainer=otc-swstacks@intel.com

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y --no-install-suggests \
    cmake protobuf-compiler libjemalloc-dev libjemalloc2 \
    gcc g++ libjpeg-dev libgl1 openmpi-bin numactl libomp5 \
    openssh-server libsm6 libxext6 libxrender-dev git wget && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/lib/llvm-10/lib/libomp.so.5 /usr/lib/libiomp5.so

COPY common/ scripts/ .
RUN pip install --no-cache-dir --upgrade pip \
    && pip --no-cache-dir install --force jupyterlab \
    && pip --no-cache-dir install horovod==0.21.1 \
    && pip --no-cache install -r frameworks.txt \
    && ./install_addons.sh \
    && ./cleanup.sh \
    && rm -rf /workspace/*

COPY ./licenses /workspace/licenses
#--------------------------------------------------------------------
# [FULL] Frameworks and Add-ons CPU on Ubuntu
#--------------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as ubuntu-full
LABEL maintainer=otc-swstacks@intel.com

COPY --from=ubuntu-full-base / /
SHELL ["/bin/bash",  "-c"]
