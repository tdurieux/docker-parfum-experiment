FROM debian:11-slim
RUN apt-get update && apt-get install --no-install-recommends -y build-essential git cmake \
    libgnutls28-dev libarchive-dev zlib1g-dev protobuf-compiler \
    libprotobuf-dev libprotoc-dev liblzma-dev bison flex && rm -rf /var/lib/apt/lists/*;
COPY . /src
WORKDIR /src
RUN git submodule init && \
    git submodule update && \
    mkdir build && \
    cd build && \
    CC=gcc CXX=g++ cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    DESTDIR=build-root make install

FROM debian:11-slim
RUN apt-get update && apt-get install --no-install-recommends -y libprotobuf23 && rm -rf /var/lib/apt/lists/*;
COPY --from=0 /src/build/build-root/ /

EXPOSE 6969