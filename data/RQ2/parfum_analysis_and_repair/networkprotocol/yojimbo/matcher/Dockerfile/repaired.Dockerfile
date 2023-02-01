FROM golang

RUN apt-get -y update && apt-get install --no-install-recommends -y wget make g++ dh-autoreconf pkg-config openssl && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz && \
    tar -zxvf libsodium-*.tar.gz && \
    cd libsodium-* && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && make check && \
    make install && \
    cd .. && \
    rm -rf libsodium* && \
    ldconfig && rm libsodium-*.tar.gz

RUN go get -u github.com/gorilla/mux
RUN go get -u github.com/gorilla/context

RUN cd /go/bin && \
    openssl genrsa -out server.key 4096 && \
    openssl ecparam -genkey -name secp384r1 -out server.key && \
    openssl req -new -x509 -sha256 -key server.key -out server.pem -days 3650 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost"

ADD matcher.go matcher.go

RUN go build -o /go/bin/matcher matcher.go

WORKDIR /go/bin

ENTRYPOINT /go/bin/matcher

EXPOSE 8080
