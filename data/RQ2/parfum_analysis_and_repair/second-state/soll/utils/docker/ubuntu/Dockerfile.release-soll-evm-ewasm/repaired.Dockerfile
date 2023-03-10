FROM secondstate/soll:ubuntu-evm-llvm AS SOLL

WORKDIR /
RUN git clone https://github.com/second-state/soll.git

WORKDIR /soll
RUN git checkout 0.0.3-pre
RUN mkdir -p build
WORKDIR /soll/build
RUN cmake -DCMAKE_BUILD_TYPE=Debug \
        -DSOLL_ENABLE_EVM=true \
        -DLLVM_CMAKE_PATH=/evm_llvm_build .. \
    && make -j8

RUN cp ./tools/soll/soll /tmp/soll

FROM secondstate/soll:ubuntu-base

COPY --from=SOLL /tmp/soll /

WORKDIR /