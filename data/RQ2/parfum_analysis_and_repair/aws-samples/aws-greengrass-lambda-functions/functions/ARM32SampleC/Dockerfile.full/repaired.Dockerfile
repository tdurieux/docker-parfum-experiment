FROM arm32v7/ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git binutils build-essential ca-certificates zip unzip cmake zlib1g-dev libssl-dev curl libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/aws/aws-sdk-cpp.git
RUN cd aws-sdk-cpp && \
    cmake -j24 . && \
    make -j24 install

RUN git clone https://github.com/aws/aws-greengrass-core-sdk-c.git
RUN cd aws-greengrass-core-sdk-c && \
    mkdir build && cd build && \
    cmake .. && \
    cmake -j24 --build . && \
    make -j24 install

RUN cd aws-greengrass-core-sdk-c/aws-greengrass-core-sdk-c-example && \
    cmake -j24 . && \
    make -j24
