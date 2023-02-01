FROM ubuntu:trusty

RUN apt update -y && apt upgrade -y && apt install --no-install-recommends -y build-essential cmake && rm -rf /var/lib/apt/lists/*;

ADD src/ src/

ADD CMakeLists.txt CMakeLists.txt

RUN mkdir build && \
    cd build && \
    cmake ../ && \
    make
