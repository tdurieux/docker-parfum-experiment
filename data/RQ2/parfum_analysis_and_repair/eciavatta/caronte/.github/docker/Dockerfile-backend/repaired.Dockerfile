FROM golang:1.16

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install -qq \
	git \
	pkg-config \
	libpcap-dev \
	libhyperscan-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /caronte

COPY . ./

RUN go mod download && \
    go build

ENTRYPOINT go test -v -race -covermode=atomic
