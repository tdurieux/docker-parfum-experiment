FROM ubuntu:18.04

# Install build essential
RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

# Install Raspbian toolchain
ADD https://s3.amazonaws.com/RTI/Community/ports/toolchains/raspbian-toolchain-gcc-4.7.2-linux64.tar.gz /build/toolchain/
RUN tar -xzf /build/toolchain/raspbian-toolchain-gcc-4.7.2-linux64.tar.gz -C /build/toolchain && rm /build/toolchain/raspbian-toolchain-gcc-4.7.2-linux64.tar.gz
ENV PATH="/build/toolchain/raspbian-toolchain-gcc-4.7.2-linux64/bin:${PATH}"

ADD toolchain-arm-linux.cmake /build/toolchain/

VOLUME /build/workspace
WORKDIR /build/workspace

CMD mkdir ./bin; cd ./bin; \
    cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE:FILEPATH="/build/toolchain/toolchain-arm-linux.cmake" -DBUILD_NUM=$TRAVIS_BUILD_NUMBER ..; \
    make; \
    cpack -G DEB
