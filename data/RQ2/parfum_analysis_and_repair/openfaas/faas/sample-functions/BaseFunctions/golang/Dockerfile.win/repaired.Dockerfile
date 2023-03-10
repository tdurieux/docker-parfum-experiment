FROM golang:1.9.7-windowsservercore
MAINTAINER alexellis2@gmail.com
ENTRYPOINT []

WORKDIR /go/src/github.com/openfaas/faas/sample-functions/golang
COPY . /go/src/github.com/openfaas/faas/sample-functions/golang
RUN go build

ADD https://github.com/openfaas/faas/releases/download/0.13.0/fwatchdog.exe /watchdog.exe

EXPOSE 8080
ENV fprocess="golang.exe"

ENV suppress_lock="true"

CMD ["watchdog.exe"]