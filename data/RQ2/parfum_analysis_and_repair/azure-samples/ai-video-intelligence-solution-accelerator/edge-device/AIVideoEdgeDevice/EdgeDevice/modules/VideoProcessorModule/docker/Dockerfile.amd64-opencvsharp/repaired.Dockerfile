FROM opencvfull:4.1.0 as build-env

RUN mkdir -p /opencvsharp-build/install/usr/local \
    && cd /opencvsharp-build \
    && git clone https://github.com/shimat/opencvsharp.git \ 
    && cd /opencvsharp-build/opencvsharp \
    && git checkout 4.1.0.20190417 \
    && cd /opencvsharp-build/opencvsharp/src \
    && mkdir -p build \
    && cd build \
    && cmake -D CMAKE_INSTALL_PREFIX=/opencvsharp/out .. \ 
    && make -j4 \
    && make install
    
FROM ubuntu:xenial

WORKDIR /opencvsharp
# Puts libOpenCvSharpExtern.so in /opencvsharp/lib
COPY --from=build-env /opencvsharp/out ./