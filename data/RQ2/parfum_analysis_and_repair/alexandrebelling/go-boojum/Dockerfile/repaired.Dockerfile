FROM ubuntu:16.04

# Install numerous dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    build-essential \
    libboost-all-dev \
    libssl-dev \
    cmake \
    libprocps-dev \
    libgmp-dev \
    pkg-config \
    software-properties-common \
    git && rm -rf /var/lib/apt/lists/*;

# Install golang 1.11
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt-get update
RUN apt-get install --no-install-recommends -y golang-1.11 && rm -rf /var/lib/apt/lists/*;
ENV GOPATH /usr/src/go
ENV GOROOT /usr/lib/go-1.11
ENV GO11MODULE=on
ENV PATH $PATH:$GOROOT/bin

# Build cpp dependencies
RUN mkdir -p /go-boojum/aggregator
WORKDIR /go-boojum/aggregator
COPY ./aggregator .
RUN make build-all

# Setup the module
WORKDIR /go-boojum/
COPY . .
RUN go mod download /go-boojum


