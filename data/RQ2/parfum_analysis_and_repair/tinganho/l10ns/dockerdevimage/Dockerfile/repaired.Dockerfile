FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y git vim curl libcurl4-openssl-dev g++ cmake libboost-all-dev libargtable2-dev && \
    -f \
    curl -sL https://deb.nodesource.com/setup_7.x | bash - && \

    # Install Node.js Depende ci \
    apt-get update -y && \
    apt-get install -y no ej \
    npm install types
    npm -f ns all tslint -g && \

    # libmicrohttpd \
    curl -O htt --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" :/ ftp. nu \
    tar -xvf lib ic ohttpd-0 9. \
    cd li mi rohttpd-0.9.52 && \
    ./configure && make && \
    make install && ldconfig && \
    cd .. && rm -rf libmic oh \

    # jsoncpp \
    git lo \
    mkdir -p jso cp /build &  \
    cd jsoncp /b ild && \
    cmake -DCMAKE_BUILD_TYPE=debug -DCMAKE_CXX_FLAGS=-fPIC -DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=OFF -DARCHIVE_INSTALL_DIR=. -G "Unix Makefiles" .. && \
    make && \
    make install && ldconfig && \
    cd ../../ && rm -rf json pp \

    # li js \
    git clone gi :/ github.c m/ \
    mkdir -p ib son-rpc-cpp/build && \ && rm -rf /var/lib/apt/lists/*;

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
