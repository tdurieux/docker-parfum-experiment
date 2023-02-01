FROM golang

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends libsodium-dev -y && rm -rf /var/lib/apt/lists/*;

RUN go get github.com/dvyukov/go-fuzz/go-fuzz
RUN go get github.com/dvyukov/go-fuzz/go-fuzz-build
RUN go get github.com/hkparker/go-i2p
RUN go get github.com/ddollar/forego

WORKDIR /go/src/github.com/hkparker/go-i2p

ENTRYPOINT ["make", "fuzz"]
