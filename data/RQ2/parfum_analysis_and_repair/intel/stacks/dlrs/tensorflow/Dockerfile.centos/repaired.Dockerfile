#--------------------------------------------------------------------
# [ARGS] Arguments for FROM statements
#--------------------------------------------------------------------
ARG centos_ver=8
#--------------------------------------------------------------------
# [BUILD-COMMON] Common build tools
#--------------------------------------------------------------------
FROM centos:$centos_ver as common_build_tools

RUN yum update -y \
    && yum install -y python3-pip python3-devel wget git cmake curl \
    && yum groupinstall -y 'Development Tools' && rm -rf /var/cache/yum

# Install gcc9
RUN dnf -y install gcc-toolset-9-gcc gcc-toolset-9-gcc-c++
ENV PATH=/opt/rh/gcc-toolset-9/root/usr/bin:$PATH

RUN ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /buildir
COPY scripts/ patches/ .

#--------------------------------------------------------------------
# [TF BUILDER] Builder Stage - Tensorflow on Centos
#--------------------------------------------------------------------
FROM common_build_tools as tf_builder
LABEL maintainer=otc-swstacks@intel.com
ARG tf_ver

# Install SW packages
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum -y install bc jemalloc-devel which \
    	pkg-config zip unzip go-toolset && rm -rf /var/cache/yum

# Install Bazel
RUN go get github.com/bazelbuild/bazelisk \
    && export PATH=$PATH:~/go/bin/ \
    && ln -s ~/go/bin/bazelisk /usr/bin/bazel

RUN ./install_${tf_ver}_centos.sh

#--------------------------------------------------------------
# [TF CORE] DLRS Centos TF Core
#--------------------------------------------------------------
FROM centos:$centos_ver as tf_core
LABEL maintainer=otc-swstacks@intel.com

# Install SW packages
RUN yum -y update \
    && yum -y install \
    python3-pip python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && pip install --no-cache-dir --upgrade pip && rm -rf /var/cache/yum

# install optimized malloc libs
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
   && yum -y install jemalloc-devel gperftools && rm -rf /var/cache/yum

COPY --from=tf_builder /tmp/tf/ /tmp/tf/

# Install Tensorflow
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

# Install gcc9
RUN yum install -y \
    openssh-server curl openmpi openmpi-devel libgomp \
    libjpeg-devel zlib-devel numactl python3-devel make cmake git \
    && dnf -y install gcc-toolset-9-gcc gcc-toolset-9-gcc-c++ && rm -rf /var/cache/yum

ENV PATH=/usr/lib64/openmpi/bin:$PATH \
    PATH=/opt/rh/gcc-toolset-9/root/usr/bin:$PATH

# Symlink for missing libiomp5 library
RUN ln -s /usr/lib/llvm-10/lib/libomp.so.5 /usr/lib/libiomp5.so

COPY common/ scripts/ .


ENV CPATH='/usr/local/lib/python3.6/site-packages/tensorflow_core/include/tensorflow/core/framework:/usr/local/lib/python3.6/site-packages/tensorflow_core/include/' \
    C_INCLUDE_PATH=$CPATH

# Install runtime deps, frameworks and addons
WORKDIR /workspace
RUN HOROVOD_WITH_TENSORFLOW=1 pip --no-cache-dir install horovod==0.21.* \
    && ./install_py_packages.sh ${tf_ver} \
    && find /usr/lib/ -follow -type f -name '*.pyc' -delete \
    && find /usr/lib/ -follow -type f -name '*.js.map' -delete \
    && rm -rf /workspace/*
# Clean routine
RUN dnf remove -y gcc-toolset-9-gcc gcc-toolset-9-gcc-c++ \
    git python3-devel cmake make

# speech to text using deepspeech
RUN pip install --no-cache-dir deepspeech==0.9.3

COPY ./licenses /workspace/licenses
#--------------------------------------------------------------
# [TF CORE] DLRS Centos TF Core
#--------------------------------------------------------------
FROM centos:$centos_ver as tf_full
LABEL maintainer=otc-swstacks@intel.com

COPY --from=tf_full_base / /
SHELL ["/bin/bash", "-c"]

