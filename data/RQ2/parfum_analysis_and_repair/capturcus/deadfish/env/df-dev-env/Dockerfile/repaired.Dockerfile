FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y git build-essential libbox2d-dev libglm-dev wget libz-dev libgl1-mesa-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev python3 libpulse-dev python3-pip && \
    pip3 install --no-cache-dir flatbuffers && cd / && \
    wget https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.gz && \
    tar xvf boost_1_74_0.tar.gz && cd boost_1_74_0 && ./bootstrap.sh && \
    ./b2 --with-system --with-program_options --with-headers install && cd / && rm -rf boost_1_74_0 boost_1_74_0.tar.gz && \
    wget https://github.com/Kitware/CMake/releases/download/v3.18.3/cmake-3.18.3-Linux-x86_64.sh && \
    chmod +x cmake-3.18.3-Linux-x86_64.sh && mkdir -p /opt/cmake && \
    ./cmake-3.18.3-Linux-x86_64.sh --skip-license --prefix=/opt/cmake && \
    ln -s /opt/cmake/bin/cmake /usr/bin/cmake && rm -rf cmake-3.18.3-Linux-x86_64.sh && \
    git clone https://github.com/google/flatbuffers && cd flatbuffers && \
    mkdir build && cd build && cmake .. && make install -j5 && cd / && rm -rf flatbuffers && \
    cd / && mkdir agones && cd agones && wget https://github.com/googleforgames/agones/releases/download/v1.10.0/agonessdk-1.10.0-linux-arch_64.tar.gz && \
    tar xvf agonessdk-1.10.0-linux-arch_64.tar.gz && rm -rf agonessdk-1.10.0-linux-arch_64.tar.gz && \
    mv * /usr/local/ && cd / && rm -rf agones && \
    mkdir /emsdk && chmod -R 777 /emsdk && \
    rm -rf /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    adduser --disabled-password --gecos "" ubuntu && rm -rf /var/lib/apt/lists/*;
CMD [ "tail", "-f", "/dev/null" ]
