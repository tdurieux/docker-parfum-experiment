FROM golang:latest AS build 

WORKDIR /go/judge

COPY go.mod go.sum /go/judge/

RUN go mod download -x

COPY ./ /go/judge

RUN go generate ./cmd/executorserver/version \
    && CGO_ENABLE=0 go build -v -tags nomsgpack -o executorserver ./cmd/executorserver 

FROM debian:latest

WORKDIR /opt

COPY --from=build /go/judge/executorserver /go/judge/mount.yaml /opt/

EXPOSE 5050/tcp 5051/tcp

ENTRYPOINT ["./executorserver"]