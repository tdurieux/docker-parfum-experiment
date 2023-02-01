FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git binutils build-essential ca-certificates zip unzip cmake zlib1g-dev libssl-dev curl libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/aws/aws-sdk-cpp.git
RUN cd aws-sdk-cpp && \
    cmake -j8 . && \
    make install -j8

RUN git clone https://github.com/aws/aws-greengrass-core-sdk-c.git
RUN cd aws-greengrass-core-sdk-c && \
    mkdir build && cd build && \
    cmake .. && \
    cmake -j8 --build . && \
    make install -j8

RUN cd aws-greengrass-core-sdk-c/aws-greengrass-core-sdk-c-example && \
    cmake -j8 . && \
    make -j8
