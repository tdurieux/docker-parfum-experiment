# Build OG from alpine based golang environment
FROM golang:1.12-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ENV GOPROXY https://goproxy.cn
ENV GO111MODULE on

ADD . /OG
WORKDIR /OG
RUN make og

# Copy OG into basic alpine image
FROM alpine:latest

RUN apk add --no-cache curl iotop busybox-extras

COPY --from=builder OG/deployment/config.toml .
COPY --from=builder OG/deployment/genesis.json .
COPY --from=builder OG/build/og .

# for a temp running folder. This should be mounted from the outside