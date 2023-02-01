FROM golang:stretch AS build-env

WORKDIR /go/src/github.com/evmos/evmos

RUN apt-get update -y
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN make build

FROM golang:stretch

RUN apt-get update -y
RUN apt-get install --no-install-recommends ca-certificates jq -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

COPY --from=build-env /go/src/github.com/evmos/evmos/build/evmosd /usr/bin/evmosd

EXPOSE 26656 26657 1317 9090

CMD ["evmosd"]
