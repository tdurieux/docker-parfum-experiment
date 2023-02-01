FROM cochain/eos-builder as builder
ARG branch=master
ARG symbol=EOC

RUN git clone -b $branch https://github.com/eoscochain/eoscochain.git eos --recursive
RUN cd eos && echo "$branch:$(git rev-parse HEAD)" > /etc/eosio-version \
    && cmake -H. -B"/tmp/build" -GNinja -DCMAKE_BUILD_TYPE=Release -DWASM_ROOT=/opt/wasm -DCMAKE_CXX_COMPILER=clang++ \
       -DCMAKE_C_COMPILER=clang -DCMAKE_INSTALL_PREFIX=/tmp/build -DSecp256k1_ROOT_DIR=/usr/local -DCORE_SYMBOL_NAME=$symbol \
       -DOPENSSL_ROOT_DIR=/usr/include/openssl -DOPENSSL_INCLUDE_DIR=/usr/include/openssl \
       -DBUILD_MYSQL_DB_PLUGIN=true \
    && cmake --build /tmp/build --target install && rm /tmp/build/bin/eosiocpp

FROM ubuntu:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssl ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/lib/* /usr/local/lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libmysqlclient.so* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /tmp/build/bin /opt/eosio/bin
COPY --from=builder /tmp/build/contracts /contracts
COPY --from=builder /eos/Docker/config.ini /
COPY --from=builder /etc/eosio-version /etc
COPY --from=builder /eos/Docker/nodeosd.sh /opt/eosio/bin/nodeosd.sh
ENV EOSIO_ROOT=/opt/eosio
RUN chmod +x /opt/eosio/bin/nodeosd.sh
ENV LD_LIBRARY_PATH /usr/local/lib
VOLUME /opt/eosio/bin/data-dir
ENV PATH /opt/eosio/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
