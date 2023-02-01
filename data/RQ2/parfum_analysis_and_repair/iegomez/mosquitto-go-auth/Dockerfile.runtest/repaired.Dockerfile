#Use debian:stable-slim as a builder and then copy everything.
FROM debian:stable-slim as builder

#Set mosquitto and plugin versions.
#Change them for your needs.
ENV MOSQUITTO_VERSION=1.6.10
ENV PLUGIN_VERSION=0.6.1
ENV GO_VERSION=1.13.8

WORKDIR /app

#Get mosquitto build dependencies.
RUN apt-get update && apt-get install --no-install-recommends -y libc-ares2 libc-ares-dev openssl uuid uuid-dev wget build-essential git && rm -rf /var/lib/apt/lists/*;

RUN if [ "$(echo $MOSQUITTO_VERSION | head -c 1)" != 2 ]; then \
        apt install --no-install-recommends -y libwebsockets-dev; rm -rf /var/lib/apt/lists/*; \
    else \
        export LWS_VERSION=2.4.2  && \
        wget https://github.com/warmcat/libwebsockets/archive/v${LWS_VERSION}.tar.gz -O /tmp/lws.tar.gz && \
        mkdir -p /build/lws && \
        tar --strip=1 -xf /tmp/lws.tar.gz -C /build/lws && \
        rm /tmp/lws.tar.gz && \
        cd /build/lws && \
        cmake . \
            -DCMAKE_BUILD_TYPE=MinSizeRel \
            -DCMAKE_INSTALL_PREFIX=/usr \
            -DLWS_IPV6=ON \
            -DLWS_WITHOUT_BUILTIN_GETIFADDRS=ON \
            -DLWS_WITHOUT_CLIENT=ON \
            -DLWS_WITHOUT_EXTENSIONS=ON \
            -DLWS_WITHOUT_TESTAPPS=ON \
            -DLWS_WITH_HTTP2=OFF \
            -DLWS_WITH_SHARED=OFF \
            -DLWS_WITH_ZIP_FOPS=OFF \
            -DLWS_WITH_ZLIB=OFF && \
        make -j "$(nproc)" && \
        rm -rf /root/.cmake ; \
    fi

RUN mkdir -p mosquitto/auth mosquitto/conf.d

RUN wget https://mosquitto.org/files/source/mosquitto-${MOSQUITTO_VERSION}.tar.gz
RUN tar xzvf mosquitto-${MOSQUITTO_VERSION}.tar.gz && rm mosquitto-${MOSQUITTO_VERSION}.tar.gz

#Build mosquitto.
RUN cd mosquitto-${MOSQUITTO_VERSION} && make WITH_WEBSOCKETS=yes && make install && cd ..

#Get Go.
RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && rm go${GO_VERSION}.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin && go version && rm go${GO_VERSION}.linux-amd64.tar.gz

#Build the plugin from local source
COPY ./ ./

#Build the plugin.
RUN export PATH=$PATH:/usr/local/go/bin && export CGO_CFLAGS="-I/usr/local/include -fPIC" && export CGO_LDFLAGS="-shared" &&  make

## Everything above, is the same as Dockerfile

RUN apt-get update && apt-get install --no-install-recommends -y mariadb-server postgresql redis-server sudo && rm -rf /var/lib/apt/lists/*;

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" > /etc/apt/sources.list.d/mongodb-org-4.4.list && \
    apt-get update && \
# starting with MongoDB 4.3, the postinst for server includes "systemctl daemon-reload" (and we don't have "systemctl")
    ln -s /bin/true /usr/bin/systemctl && \
    apt-get install --no-install-recommends -y mongodb-org && \
    rm -f /usr/bin/systemctl && rm -rf /var/lib/apt/lists/*;

# Pre-compilation of test for speed-up latest re-run
RUN export PATH=$PATH:/usr/local/go/bin && go test -c ./backends -o /dev/null