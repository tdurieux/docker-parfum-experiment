FROM golang:1-stretch as builder


WORKDIR /root

ENV GOFLAGS "-mod=readonly"
ARG version

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

COPY cmd cmd
COPY internal internal
COPY model model
COPY messenger messenger
COPY apis apis

RUN echo $version

RUN go build -ldflags="-X 'github.com/livepeer/stream-tester/model.Version=$version' -X 'github.com/livepeer/stream-tester/model.IProduction=true'" cmd/streamtester/streamtester.go
RUN go build -ldflags="-X 'github.com/livepeer/stream-tester/model.Version=$version' -X 'github.com/livepeer/stream-tester/model.IProduction=true'" cmd/recordtester/recordtester.go


FROM debian:stretch-slim

WORKDIR /root
# RUN apt update && apt install -y  ca-certificates jq libgnutls30 && apt clean
RUN apt update && apt install --no-install-recommends -y ca-certificates && apt clean && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /root/streamtester streamtester
COPY --from=builder /root/recordtester recordtester

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# RUN /root/recordtester -help
