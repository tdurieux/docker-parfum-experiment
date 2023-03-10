FROM swift as base

RUN apt-get -qqy update && apt-get install --no-install-recommends -y \
    libssl-dev \
    g++ \
    wget \
    python3.8 python3.8-dev libpython3.8-dev python3-pip \
    pkg-config && rm -rf /var/lib/apt/lists/*;

RUN apt-get remove --purge -y cmake \
    && wget https://github.com/Kitware/CMake/releases/download/v3.17.2/cmake-3.17.2.tar.gz \
    && tar -xzf cmake-3.17.2.tar.gz ; rm cmake-3.17.2.tar.gz cd cmake-3.17.2 \
    && ./bootstrap \
    && make \
    && make install


RUN git clone --recursive https://github.com/dmlc/xgboost \
    && cd xgboost      \
    && mkdir build     \
    && cd build        \
    && cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib .. \
    && cmake ..        \
    && make -j$(nproc) \
    && make install

FROM base AS test

WORKDIR /code

COPY . ./

CMD ["swift", "test"]