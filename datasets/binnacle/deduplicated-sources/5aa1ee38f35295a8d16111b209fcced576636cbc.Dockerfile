# Simple usage with a mounted data directory:
# > docker build -t irishub .
# > docker run -v $HOME/.iris:/root/.iris iris init
# > docker run -v $HOME/.iris:/root/.iris iris start

FROM golang:1.12.5-alpine3.9 as builder

# Set up dependencies
ENV PACKAGES make gcc git libc-dev bash linux-headers eudev-dev

# Set up GOPATH & PATH

ENV GOPATH       /root/go
ENV BASE_PATH    $GOPATH/src/github.com/irisnet
ENV REPO_PATH    $BASE_PATH/irishub
ENV PATH         $GOPATH/bin:$PATH

# Add source files
COPY . $REPO_PATH/

# Install minimum necessary dependencies, build Cosmos SDK, remove packages
RUN cd $REPO_PATH && \
    apk add --no-cache $PACKAGES && \
    make get_tools && \
    make test_unit && \
    make build_linux

FROM alpine:3.9

# p2p port
EXPOSE 26656
# rpc port
EXPOSE 26657

COPY --from=builder /root/go/src/github.com/irisnet/irishub/build/ /usr/local/bin/
