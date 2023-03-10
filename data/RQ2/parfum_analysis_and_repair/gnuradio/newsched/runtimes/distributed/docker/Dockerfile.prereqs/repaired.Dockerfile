FROM ubuntu:20.04

RUN apt-get update -q  && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy \
    build-essential \
    --no-install-recommends \
    libspdlog-dev \
    libyaml-cpp-dev \
    libgtest-dev \
    libfmt-dev \
    pybind11-dev \
    python3-dev \
    python3-numpy \
    libqwt-qt5-dev \
    ninja-build \
    libboost-dev \
    libboost-program-options-dev \
    libboost-thread-dev \
    libfftw3-dev \
    git \ 
    cmake \
    pkg-config \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libzmq3-dev qt5-default && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir meson mako jinja2 pyyaml

RUN pip install --no-cache-dir fastapi
RUN pip install --no-cache-dir "uvicorn[standard]"

ENV PREFIX /prefix
WORKDIR ${PREFIX}/src
RUN git clone --recursive https://github.com/gnuradio/volk.git --branch v2.4.1 && \
cd volk && mkdir build && cd build &&cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$prefix && make install -j8
WORKDIR ${PREFIX}/src
RUN git clone https://github.com/google/flatbuffers.git --branch v2.0.0 && \
cd flatbuffers && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make -j8 && make install
WORKDIR ${PREFIX}/src
