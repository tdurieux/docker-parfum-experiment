FROM ubuntu:20.04

# Installing necessary packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc g++ gcc-mingw-w64 g++-mingw-w64 nsis make wget unzip \
    curl perl binutils zip libssl1.1 libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -OL https://packages.wazuh.com/utils/cmake/cmake-3.18.3.tar.gz && \
    tar -zxvf cmake-3.18.3.tar.gz && \
    cd cmake-3.18.3 && \
    ./bootstrap && make -j$(nproc) && make install && \
    ln -s /usr/local/bin/cmake /usr/bin/cmake && cd / && rm -rf cmake-* && rm cmake-3.18.3.tar.gz

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
