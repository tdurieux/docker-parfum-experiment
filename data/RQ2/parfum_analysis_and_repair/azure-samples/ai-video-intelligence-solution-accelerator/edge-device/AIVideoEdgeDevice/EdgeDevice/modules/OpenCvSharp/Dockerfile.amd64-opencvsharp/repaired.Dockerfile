FROM opencvfull:4.1.0

RUN mkdir -p /out \
    && mkdir -p /out \
    && cp /opencv-build/install/usr/local/lib/l* /out \
    && mkdir -p /opencvsharp-build/install/usr/local \
    && cd /opencvsharp-build \
    && git clone https://github.com/shimat/opencvsharp.git \ 
    && cd /opencvsharp-build/opencvsharp \
    && git checkout 4.1.0.20190417 \
    && cd /opencvsharp-build/opencvsharp/src \
    && mkdir -p build \
    && cd build \
    && cmake -D CMAKE_INSTALL_PREFIX=/opencvsharp-build/install/usr/local .. \ 
    && make -j4 \
    && make install \ 
    && cp /opencvsharp-build/install/usr/local/lib/* /out   