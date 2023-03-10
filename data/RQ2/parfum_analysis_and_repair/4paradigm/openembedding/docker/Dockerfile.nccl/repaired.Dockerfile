FROM tensorflow/tensorflow:latest-gpu
RUN RUN apt-get update && apt-get update && apt-get install --no-install-recommends -y gcc-7 g++-7 cmake \
    openssh-client openmpi-bin libopenmpi-dev vim wget curl \
    build-essential devscripts debhelper fakeroot && rm -rf /var/lib/apt/lists/*;
RUN NCCL=2.9.9-1 && mkdir nccl && cd nccl && \
    wget https://github.com/NVIDIA/nccl/archive/v${NCCL}.tar.gz && tar -xzf v{NCCL}.tar.gz && \
    cd nccl-{NCCL} && make src.build && make pkg.debian.build && \
    apt-get -y --no-install-recommends install ./build/pkg/deb/libnccl2_*_amd64.deb ./build/pkg/deb/libnccl-dev_*_amd64.deb && rm v{NCCL}.tar.gz && rm -rf /var/lib/apt/lists/*;
RUN HOROVOD_GPU_OPERATIONS=NCCL pip3 --no-cache-dir install horovod
RUN pip3 install --no-cache-dir pandas scikit-learn deepctr
ADD . /openembedding
RUN pip3 install --no-cache-dir /openembedding/output/dist/openembedding-*.tar.gz
WORKDIR /openembedding
