FROM nvidia/cuda:10.2-devel-ubuntu18.04 as builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        git \
        gnupg2 \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root

ENV CMAKE_VERSION=3.18.4
RUN wget -q https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz && \
    tar xf *.tar.gz && \
    rm *.tar.gz
ENV PATH=$PATH:/root/cmake-$CMAKE_VERSION-Linux-x86_64/bin

ENV SENTENCEPIECE_VERSION=v0.1.95
RUN wget https://github.com/google/sentencepiece/archive/$SENTENCEPIECE_VERSION.tar.gz && \
    tar xf $SENTENCEPIECE_VERSION.tar.gz && \
    rm $SENTENCEPIECE_VERSION.tar.gz && \
    cd sentencepiece-* && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_CXX_FLAGS=${CXX_FLAGS} -DSPM_TCMALLOC_STATIC=ON -DSPM_ENABLE_SHARED=OFF .. && \
    VERBOSE=1 make -j4 install && \
    cd /root && \
    rm -r sentencepiece-*

ENV CUDA_ARCH_LIST="7.5"

ENV CTRANSLATE2_VERSION=v1.17.0
RUN git clone https://github.com/OpenNMT/CTranslate2.git && \
    cd CTranslate2 && \
    git checkout $CTRANSLATE2_VERSION && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_CXX_FLAGS=${CXX_FLAGS} -DLIB_ONLY=ON -DWITH_CUDA=ON -DWITH_MKL=OFF -DOPENMP_RUNTIME=NONE -DCUDA_ARCH_LIST="${CUDA_ARCH_LIST}" .. && \
    VERBOSE=1 make -j4 install && \
    cd /root && \
    rm -r CTranslate2

ENV LD_LIBRARY_PATH=/opt/intel/lib/intel64/
COPY CMakeLists.txt .
COPY main.cc .
RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_CXX_FLAGS=${CXX_FLAGS} .. && \
    VERBOSE=1 make -j4

RUN mkdir /opt/wngt2020 && \
    cp /root/build/run /opt/wngt2020 && \
    cp -P /usr/lib/x86_64-linux-gnu/libcublas*.so* /opt/wngt2020 && \
    cp /usr/local/lib/libctranslate2.so /opt/wngt2020

FROM nvidia/cuda:10.2-base-ubuntu18.04

COPY --from=builder /opt/wngt2020 /opt/wngt2020
ENV LD_LIBRARY_PATH=/opt/wngt2020

ARG MODEL_PATH
COPY ${MODEL_PATH} /model
COPY run.sh /