FROM golang:1.16 AS build-env

RUN mkdir -p /workspace
WORKDIR /workspace

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

ADD go.mod go.sum ./

RUN go mod download

ADD . .

RUN go build -o go.d.plugin github.com/netdata/go.d.plugin/cmd/godplugin

FROM netdata/netdata

ADD ./mocks/netdata/netdata.conf /etc/netdata/
ADD ./mocks/conf.d /usr/lib/netdata/conf.d
COPY --from=build-env /workspace/go.d.plugin /usr/libexec/netdata/plugins.d/go.d.plugin