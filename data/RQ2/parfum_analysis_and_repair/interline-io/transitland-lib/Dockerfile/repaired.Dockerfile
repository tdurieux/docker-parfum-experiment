FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    jq \
    libsqlite3-mod-spatialite \
    spatialite-bin \
    git \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

# Until 19.04 has 1.12.
RUN add-apt-repository ppa:longsleep/golang-backports && apt-get update && apt-get install --no-install-recommends -y golang-1.12 && rm -rf /var/lib/apt/lists/*;
ENV PATH /usr/lib/go-1.12/bin:$PATH

WORKDIR /src
ADD go.mod .
RUN go mod download
ADD . .
RUN go version
RUN go build . && go test -v ./... && (cd cmd/transitland && go build .)
