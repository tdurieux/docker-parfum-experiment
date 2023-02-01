FROM ubuntu:19.10@sha256:bd5f4f235eb31768b2c5caf1988bbdc182d4fc3cb6ee4aca6c6d74613f256140

USER root
RUN apt-get update && apt-get install -qq -y \
      autoconf \
      cmake \
      build-essential \
      emscripten \
      git \
      libtool-bin \
      python2.7 \
      nodejs \
      npm

RUN npm install -g npm
RUN useradd -u 1000 -ms /bin/bash user
USER user
WORKDIR /home/user
RUN git clone https://github.com/juj/emsdk.git

ENV EMSCRIPTEN_VERSION sdk-tag-1.39.15-64bit-upstream

RUN cd emsdk && \
    ./emsdk update-tags && \
    ./emsdk install $EMSCRIPTEN_VERSION && \
    ./emsdk activate --embedded $EMSCRIPTEN_VERSION

ENV EMSDK="/home/user/emsdk"
ENV EMSDK_NODE_BIN="$EMSDK/node/12.9.1_64bit/bin"
ENV EMSCRIPTEN="$EMSDK/upstream/emscripten"
ENV PATH="$EMSDK:$EMSCRIPTEN:$EMSDK_NODE_BIN:${PATH}"
ENV EM_CONFIG="$EMSDK/.emscripten"
ENV EM_PORTS="$EMSDK/.emscripten_ports"
ENV EM_CACHE="$EMSDK/.emscripten_cache"
ENV EMSDK_NODE="$EMSDK_NODE_BIN/node"
ENV EMCC_WASM_BACKEND=1
ENV EMCC_SKIP_SANITY_CHECK=1

# Compile a program to force emcc caching
RUN mkdir -p /tmp/emcc && \
    cd /tmp/emcc && \
    printf "#include <iostream>\nint main(){ std::cout << 0; return *new int; }" > build.cpp && \
    emcc --bind -s DISABLE_EXCEPTION_CATCHING=0 build.cpp && \
    rm -rf /tmp/emcc

COPY . .

RUN mkdir embuild
WORKDIR /home/user/embuild

RUN cmake -DCMAKE_TOOLCHAIN_FILE=$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake ..
RUN cmake --build --parallel .

WORKDIR /home/user
RUN npm install
RUN npm run build
