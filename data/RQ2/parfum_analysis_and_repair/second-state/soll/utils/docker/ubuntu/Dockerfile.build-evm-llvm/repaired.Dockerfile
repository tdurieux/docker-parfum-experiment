ARG BASE=secondstate/soll:ubuntu-clang
FROM ${BASE}

RUN apt update \
    && apt install --no-install-recommends -y \
        git && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone --single-branch --branch evm_80 \
        https://github.com/etclabscore/evm_llvm.git

WORKDIR /evm_llvm/tools
RUN git clone --single-branch --branch release_80 \
        https://github.com/llvm-mirror/lld.git

RUN mkdir -p /evm_llvm_build
WORKDIR /evm_llvm_build
RUN cmake -DCMAKE_INSTALL_PREFIX=/evm_llvm_build \
        -DLLVM_ENABLE_RTTI=ON \
        -DCMAKE_BUILD_TYPE="Release" \
        -DLLVM_TARGETS_TO_BUILD="WebAssembly" -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="EVM" \
        /evm_llvm \
    && make llc -j8 \
    && make lld -j8 \
    && cmake --build . --target install -- -j 8

ENV LLVM_DIR=/evm_llvm_build
ENV CC=clang-10
ENV CXX=clang++-10

WORKDIR /
