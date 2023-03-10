FROM ubuntu:16.04
ARG GOLANG_VERSION

RUN apt-get update && apt-get install --no-install-recommends -y git libboost-all-dev wget sqlite3 autoconf build-essential shellcheck && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN wget --quiet https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz && tar -xvf go${GOLANG_VERSION}.linux-amd64.tar.gz && mv go /usr/local && rm go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOROOT=/usr/local/go \
    GOPATH=$HOME/go \
    GOPROXY=https://proxy.golang.org,https://pkg.go.dev,https://goproxy.io,direct
RUN mkdir -p $GOPATH/src/github.com/algorand
WORKDIR $GOPATH/src/github.com/algorand
COPY ./go-algorand ./go-algorand/
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH \
    BRANCH=${BRANCH} \
    CHANNEL=${CHANNEL} \
    DEFAULTNETWORK=${DEFAULTNETWORK} \
    FULLVERSION=${FULLVERSION} \
    PKG_ROOT=${PKG_ROOT}
WORKDIR $GOPATH/src/github.com/algorand/go-algorand
RUN scripts/configure_dev-deps.sh && make clean && scripts/local_install.sh -n
ENTRYPOINT ["/bin/bash"]
