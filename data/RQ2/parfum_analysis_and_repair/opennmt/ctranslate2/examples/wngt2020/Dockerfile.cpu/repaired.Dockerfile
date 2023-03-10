FROM ubuntu:20.04 as builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        build-essential \
        ca-certificates \
        gnupg2 \
        libgoogle-perftools-dev \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root

ENV CMAKE_VERSION=3.18.4
RUN wget -q https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-Linux-x86_64.tar.gz && \
    tar xf *.tar.gz && \
    rm *.tar.gz
ENV PATH=$PATH:/root/cmake-$CMAKE_VERSION-Linux-x86_64/bin

ENV ONEAPI_VERSION=2021.1.1
ENV MKL_BUILD=52
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
    apt-key add *.PUB && \
    rm *.PUB && \
    echo "deb https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        intel-oneapi-mkl-devel=$ONEAPI_VERSION-$MKL_BUILD \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CXX_FLAGS="-march=cascadelake"

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

ENV CTRANSLATE2_VERSION=v1.17.0
RUN wget https://github.com/OpenNMT/CTranslate2/archive/$CTRANSLATE2_VERSION.tar.gz && \
    tar xf $CTRANSLATE2_VERSION.tar.gz && \
    rm $CTRANSLATE2_VERSION.tar.gz && \
    cd CTranslate2-* && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_CXX_FLAGS=${CXX_FLAGS} -DLIB_ONLY=ON -DOPENMP_RUNTIME=NONE -DENABLE_CPU_DISPATCH=OFF .. && \
    VERBOSE=1 make -j4 install && \
    cd /root && \
    rm -r CTranslate2-*

ENV LD_LIBRARY_PATH=/opt/intel/lib/intel64/
COPY CMakeLists.txt .
COPY main.cc .
RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_CXX_FLAGS=${CXX_FLAGS} .. && \
    VERBOSE=1 make -j4

RUN mkdir /opt/wngt2020 && \
    cp /root/build/run /opt/wngt2020 && \
    cp /usr/local/lib/libctranslate2.so /opt/wngt2020

FROM ubuntu:20.04

COPY --from=builder /opt/wngt2020 /opt/wngt2020
ENV LD_LIBRARY_PATH=/opt/wngt2020
ENV CT2_USE_EXPERIMENTAL_PACKED_GEMM=1
ENV CT2_TRANSLATORS_CORE_OFFSET=0

ARG MODEL_PATH
COPY ${MODEL_PATH} /model
COPY run.sh /