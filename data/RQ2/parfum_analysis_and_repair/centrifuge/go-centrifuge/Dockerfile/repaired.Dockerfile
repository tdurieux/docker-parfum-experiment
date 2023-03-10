FROM golang:1.18-buster as builder

RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install wget && apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;

ADD . /go/src/github.com/centrifuge/go-centrifuge
WORKDIR /go/src/github.com/centrifuge/go-centrifuge

RUN go install -ldflags "-X github.com/centrifuge/go-centrifuge/version.gitCommit=`git rev-parse HEAD`" ./cmd/centrifuge/...

FROM debian:buster-slim
RUN apt-get -y update && apt-get -y upgrade && apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/
COPY --from=builder /go/bin/centrifuge .
COPY build/scripts/docker/entrypoint.sh /root

VOLUME ["/root/config"]

ENTRYPOINT ["/root/entrypoint.sh"]


