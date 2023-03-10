FROM ubuntu:22.04 as runtime

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
        apt-get install -y --no-install-recommends\
        python3 \
        python3.9-distutils \
        python3-pip \
        graphviz \
        swig \
        libffi7 \
        zlib1g \
        libreadline8 \
        make \
        tcl && \
        apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir matplotlib && pip3 install --no-cache-dir numpy

FROM runtime as build

RUN export DEBIAN_FRONTEND=noninteractive; \
    export DEBCONF_NONINTERACTIVE_SEEN=true; \
    echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections; \
    echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections; \
    apt-get update && \
    apt-get install --no-install-recommends -y tzdata \
        bison \
        build-essential \
        ccache \
        clang \
        cmake \
        flex \
        g++-10 \
        gawk \
        gcc-10 \
        gcovr \
        git \
        lcov \
        libffi-dev \
        libpython3.9-dev \
        libreadline-dev \
        make \
        pkg-config \
        pybind11-dev \
        swig \
        tcl-dev \
        xdot \
        zlib1g-dev && \
        apt-get clean && rm -rf /var/lib/apt/lists/*;
ENV CC=gcc-10 CXX=g++-10

RUN git clone https://github.com/YosysHQ/yosys.git && \
        cd yosys && make -j$(nproc) && make install

RUN git clone https://github.com/The-OpenROAD-Project/OpenSTA.git && \
        cd OpenSTA &&  cmake -B build . -D CMAKE_BUILD_TYPE=RELEASE  && \
        cmake --build build -j$(nproc) && cmake --build build --target install

RUN git clone https://github.com/lnis-uofu/LSOracle-Plugin.git && \
        cd LSOracle-Plugin && make YOSYS_DIR=../yosys oracle.so && \
        mkdir -p /usr/local/share/yosys/plugins && \
        cp oracle.so /usr/local/share/yosys/plugins/

FROM runtime as installed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
        apt-get install -y --no-install-recommends\
        unzip && \
        apt-get clean && \
        pip3 install --no-cache-dir matplotlib && pip3 install --no-cache-dir numpy && rm -rf /var/lib/apt/lists/*;
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/share/yosys /usr/local/share/yosys
RUN ln -s /usr/local/bin/yosys-abc /usr/local/bin/abc
