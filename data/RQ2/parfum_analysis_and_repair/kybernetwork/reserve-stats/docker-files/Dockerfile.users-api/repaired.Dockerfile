FROM golang:1.14-stretch AS build-env

COPY . /reserve-stats
WORKDIR /reserve-stats/users/cmd/users-api
RUN go build -v -mod=mod -o /users-api

FROM debian:stretch
COPY --from=build-env /users-api /

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV HTTP_ADDRESS=0.0.0.0:8002
EXPOSE 8002
ENTRYPOINT ["/users-api"]
