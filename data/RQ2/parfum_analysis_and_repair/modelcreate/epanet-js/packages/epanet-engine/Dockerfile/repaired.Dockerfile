FROM trzeci/emscripten:1.39.4

RUN apt-get update && \
    apt-get install --no-install-recommends -qqy git && \
    mkdir -p /opt/epanet/build && \
    git clone --depth 1 --branch v2.2 https://github.com/OpenWaterAnalytics/EPANET /opt/epanet/src && rm -rf /var/lib/apt/lists/*;
RUN cd /opt/epanet/build && \
    emcmake cmake ../src  && \
    emmake cmake --build . --config Release
