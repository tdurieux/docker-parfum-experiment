ARG GO_VERSION=1.12.4

# Dockerfile for swarm integration test environment.
# Use with run_in_docker.sh

FROM dockerswarm/dind:17.06.0-ce

# Install dependencies.
RUN apt-get update && apt-get install -y --no-install-recommends git file parallel netcat \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install golang
ENV GO_VERSION=${GO_VERSION}
RUN curl -f -sSL https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar -v -C /usr/local -xz
ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

# install bats
RUN cd /usr/local/src/ \
    && git clone https://github.com/sstephenson/bats.git \
    && cd bats \
    && ./install.sh /usr/local

RUN mkdir -p /go/src/github.com/docker/swarm
WORKDIR /go/src/github.com/docker/swarm/test/integration

ENTRYPOINT ["/dind"]
