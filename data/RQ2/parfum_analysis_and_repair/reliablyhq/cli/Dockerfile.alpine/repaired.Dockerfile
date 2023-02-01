FROM golang:1.18-alpine as build-env

ARG VERSION
ARG BUILD_DATE

WORKDIR /go/src/github.com/reliablyhq/cli
ADD . /go/src/github.com/reliablyhq/cli

# RUN go mod download
# NB: 'tidy' is quicker than 'download';
# seems to download only required packages listed in 'go.mod'
RUN go mod tidy

# Flags are mandatory to build for alpine docker image
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-X 'github.com/reliablyhq/cli/version.Version=$VERSION' -X 'github.com/reliablyhq/cli/version.Date=$BUILD_DATE'" -o /go/bin/reliably main.go

FROM alpine:3
COPY --from=build-env /go/bin/reliably /usr/local/bin
ENTRYPOINT ["reliably"]