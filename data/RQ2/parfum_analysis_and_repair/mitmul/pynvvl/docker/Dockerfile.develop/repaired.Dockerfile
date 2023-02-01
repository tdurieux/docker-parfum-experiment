ARG CUDA_VERSION=9.0
FROM mitmul/pynvvl:cuda-${CUDA_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-tk \
    python3-dbg \
    ffmpeg \
    gdb \
    gawk \
    chrpath && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir \
    cython \
    numpy \
    matplotlib \
    imageio

ARG CUPY_PACKAGE_NAME
RUN pip3 install --no-cache-dir ${CUPY_PACKAGE_NAME}
