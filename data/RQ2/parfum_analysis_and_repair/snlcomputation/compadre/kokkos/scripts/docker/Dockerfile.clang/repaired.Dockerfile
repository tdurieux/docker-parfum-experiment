FROM nvidia/cuda:9.2-devel

RUN apt-get update && apt-get install --no-install-recommends -y \
        bc \
        git \
        wget \
        ccache \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG CMAKE_VERSION=3.10.3
ENV CMAKE_DIR=/opt/cmake
RUN CMAKE_KEY=2D2CEF1034921684 && \
    CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION} && \
    CMAKE_SCRIPT=cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
    CMAKE_SHA256=cmake-${CMAKE_VERSION}-SHA-256.txt && \
    wget --quiet ${CMAKE_URL}/${CMAKE_SHA256} && \
    wget --quiet ${CMAKE_URL}/${CMAKE_SHA256}.asc && \
    wget --quiet ${CMAKE_URL}/${CMAKE_SCRIPT} && \
    gpg --batch --keyserver hkps.ha.pool.sks-keyservers.net --recv-keys ${CMAKE_KEY} && \
    gpg --batch --verify ${CMAKE_SHA256}.asc ${CMAKE_SHA256} && \
    grep ${CMAKE_SCRIPT} ${CMAKE_SHA256} | sha256sum --check && \
    mkdir -p ${CMAKE_DIR} && \
    sh ${CMAKE_SCRIPT} --skip-license --prefix=${CMAKE_DIR} && \
    rm ${CMAKE_SCRIPT}
ENV PATH=${CMAKE_DIR}/bin:$PATH

ENV LLVM_DIR=/opt/llvm
RUN LLVM_VERSION=8.0.0 && \
    LLVM_KEY=345AD05D && \
    LLVM_URL=http://releases.llvm.org/${LLVM_VERSION}/clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-16.04.tar.xz && \
    LLVM_ARCHIVE=llvm-${LLVM_VERSION}.tar.xz && \
    SCRATCH_DIR=/scratch && mkdir -p ${SCRATCH_DIR} && cd ${SCRATCH_DIR} && \
    wget --quiet ${LLVM_URL} --output-document=${LLVM_ARCHIVE} && \
    wget --quiet ${LLVM_URL}.sig --output-document=${LLVM_ARCHIVE}.sig && \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys ${LLVM_KEY} && \
    gpg --batch --verify ${LLVM_ARCHIVE}.sig ${LLVM_ARCHIVE} && \
    mkdir -p ${LLVM_DIR} && \
    tar -xvf ${LLVM_ARCHIVE} -C ${LLVM_DIR} --strip-components=1 && \
    echo "${LLVM_DIR}/lib" > /etc/ld.so.conf.d/llvm.conf && ldconfig && \
    rm -rf /root/.gnupg && \
    rm -rf ${SCRATCH_DIR}
ENV PATH=${LLVM_DIR}/bin:$PATH

# Workaround to find libcudart
ENV LD_LIBRARY_PATH=/usr/local/cuda/targets/x86_64-linux/lib:${LD_LIBRARY_PATH}
