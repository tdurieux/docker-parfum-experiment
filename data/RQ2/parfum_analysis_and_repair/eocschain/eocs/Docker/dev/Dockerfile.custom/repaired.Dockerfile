FROM cochain/eos-builder
ARG branch=master
ARG symbol=EOC

RUN git clone -b $branch https://github.com/eoscochain/eoscochain.git eos --recursive \
    && cd eos && echo "$branch:$(git rev-parse HEAD)" > /etc/eosio-version \
    && cmake -H. -B"/opt/eosio" -GNinja -DCMAKE_BUILD_TYPE=Release -DWASM_ROOT=/opt/wasm -DCMAKE_CXX_COMPILER=clang++ \
       -DCMAKE_C_COMPILER=clang -DCMAKE_INSTALL_PREFIX=/opt/eosio  -DSecp256k1_ROOT_DIR=/usr/local -DCORE_SYMBOL_NAME=$symbol \
       -DOPENSSL_ROOT_DIR=/usr/include/openssl -DOPENSSL_INCLUDE_DIR=/usr/include/openssl \
       -DBUILD_MYSQL_DB_PLUGIN=true \
    && cmake --build /opt/eosio --target install \
    && mv /eos/Docker/config.ini / && mv /opt/eosio/contracts /contracts && mv /eos/Docker/nodeosd.sh /opt/eosio/bin/nodeosd.sh && mv tutorials /tutorials \
    && rm -rf /eos

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install openssl ca-certificates vim psmisc python3-pip && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir numpy
ENV EOSIO_ROOT=/opt/eosio
RUN chmod +x /opt/eosio/bin/nodeosd.sh
ENV LD_LIBRARY_PATH /usr/local/lib
VOLUME /opt/eosio/bin/data-dir
ENV PATH /opt/eosio/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
