FROM golang:alpine AS build

WORKDIR /go/judge

RUN apk update && apk add --no-cache git

COPY go.mod go.sum /go/judge/

RUN go mod download -x

COPY ./ /go/judge

RUN go generate ./cmd/executorserver/version \
    && CGO_ENABLE=0 go build -v -tags nomsgpack -o executorserver ./cmd/executorserver

FROM alpine:latest

WORKDIR /opt

COPY --from=build /go/judge/executorserver /go/judge/mount.yaml /opt/

EXPOSE 5050/tcp 5051/tcp

ENTRYPOINT ["./executorserver"]
