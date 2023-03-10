# Builder image, produces a statically linked binary
FROM golang:1.12.1-alpine3.9 as node-build


RUN apk update && apk add --no-cache bash make git gcc libstdc++ g++ musl-dev
RUN apk add --no-cache \
  --repository http://nl.alpinelinux.org/alpine/edge/community \
  leveldb-dev

WORKDIR /src

ADD . ./

# RUN go test -mod=vendor -cover ./dkgnode ./logging ./pvss ./common ./tmabci

WORKDIR /src/cmd/dkgnode

RUN go build -mod=vendor


# final image
FROM golang:1.12.1-alpine3.9

RUN apk update && apk add --no-cache bash make git gcc libstdc++ g++ musl-dev
RUN apk update && apk add ca-certificates --no-cache
RUN apk add --no-cache \
  --repository http://nl.alpinelinux.org/alpine/edge/community \
  leveldb

# add delve debugger
RUN go get -u github.com/go-delve/delve/cmd/dlv

RUN mkdir -p /torus

COPY --from=node-build /src/cmd/dkgnode/dkgnode /torus/dkgnode

EXPOSE 443 80 1080 26656 26657 18080 40000
VOLUME ["/torus", "/root/https"]
CMD ["dlv", "exec", "/torus/dkgnode", "--listen=:40000", "--headless=true", "--api-version=2", "--log"]
