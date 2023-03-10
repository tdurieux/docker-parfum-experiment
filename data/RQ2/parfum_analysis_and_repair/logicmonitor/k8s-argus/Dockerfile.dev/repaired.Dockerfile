FROM golang:1.14 as build
WORKDIR $GOPATH/src/github.com/logicmonitor/k8s-argus
ARG VERSION
COPY ./ ./
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /argus -ldflags "-X \"github.com/logicmonitor/k8s-argus/pkg/constants.Version=${VERSION}\""

FROM alpine:3.6
LABEL maintainer="LogicMonitor <argus@logicmonitor.com>"
RUN apk --update --no-cache add ca-certificates \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apk/*
WORKDIR /app
COPY --from=build /argus /bin

ENTRYPOINT ["argus"]
