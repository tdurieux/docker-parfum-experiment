FROM nvcr.io/nvidia/pytorch:20.03-py3

MAINTAINER FastSeq Team (fastseq@microsoft.com)

##############################################################################
# Temporary Installation Directory
##############################################################################
ENV STAGE_DIR=/tmp
RUN mkdir -p ${STAGE_DIR}


##############################################################################
# Mellanox OFED
##############################################################################
ENV MLNX_OFED_VERSION=4.6-1.0.1.1
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y lsb-release udev && cd ${STAGE_DIR} && \
    wget -q -O - https://www.mellanox.com/downloads/ofed/MLNX_OFED-${MLNX_OFED_VERSION}/MLNX_OFED_LINUX-${MLNX_OFED_VERSION}-ubuntu18.04-x86_64.tgz | tar xzf - && \
    cd MLNX_OFED_LINUX-${MLNX_OFED_VERSION}-ubuntu18.04-x86_64 && \
    ./mlnxofedinstall --user-space-only --without-fw-update --all -q && \
    cd ${STAGE_DIR} && \
    rm -rf ${STAGE_DIR}/MLNX_OFED_LINUX-${MLNX_OFED_VERSION}-ubuntu18.04-x86_64* && rm -rf /var/lib/apt/lists/*;


##############################################################################
# nv_peer_mem
##############################################################################
RUN apt-get update && \
    apt-get install --no-install-recommends -y debhelper && \
    git clone https://github.com/Mellanox/nv_peer_memory.git ${STAGE_DIR}/nv_peer_memory && \
    cd ${STAGE_DIR}/nv_peer_memory && \
    git checkout tags/1.1-0 && \
    ./build_module.sh && rm -rf /var/lib/apt/lists/*;

RUN cd ${STAGE_DIR} && \
    tar xzf ${STAGE_DIR}/nvidia-peer-memory_1.1.orig.tar.gz && \
    cd ${STAGE_DIR}/nvidia-peer-memory-1.1 && \
    apt-get install --no-install-recommends -y dkms && \
    dpkg-buildpackage -us -uc && \
    dpkg -i ${STAGE_DIR}/nvidia-peer-memory_1.1-0_all.deb && rm ${STAGE_DIR}/nvidia-peer-memory_1.1.orig.tar.gz && rm -rf /var/lib/apt/lists/*;


##############################################################################
# Installation/NLP Utilities
##############################################################################
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir yapf >=v0.30.0 && \
    pip install --no-cache-dir absl-py >=v0.9.0 && \
    pip install --no-cache-dir filelock >=v3.0.12 && \
    pip install --no-cache-dir requests >=v2.24.0 && \
    pip install --no-cache-dir gitpython >=v3.1.7 && \
    pip install --no-cache-dir rouge_score==v0.0.4 && \
    pip install --no-cache-dir fairseq==v0.10.2 && \
    pip install --no-cache-dir transformers==v4.12.0 && \
    pip install --no-cache-dir pytorch-transformers==1.0.0 && \
    pip install --no-cache-dir sentencepiece==0.1.90


##############################################################################
# FastSeq
##############################################################################
RUN cd / && \
    git clone https://github.com/microsoft/fastseq.git fastseq && \
    cd fastseq && \
    pip install --no-cache-dir -e .

WORKDIR "/fastseq"
