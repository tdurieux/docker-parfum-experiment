FROM ubuntu:20.04 AS hub-test
RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y gcc make git curl file sudo \
    && curl -f -sSL https://get.docker.com/ | sh && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/udhos/update-golang.git \
    && cd update-golang \
    && sudo RELEASE=1.18.1 ./update-golang.sh \
    && ln -s /usr/local/go/bin/go /usr/bin/go
WORKDIR $GOPATH/src/github.com/plgd-dev
RUN git clone https://github.com/plgd-dev/kit.git
WORKDIR $GOPATH/src/github.com/plgd-dev/kit/cmd/certificate-generator
RUN go mod download
RUN go build -o /usr/bin/cert-tool
WORKDIR $GOPATH/src/github.com/plgd-dev/hub
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN ( cd /usr/local/go && patch -p1 < $GOPATH/src/github.com/plgd-dev/hub/tools/docker/patches/shrink_tls_conn.patch )
# RUN go mod tidy
# RUN go test ./... || true