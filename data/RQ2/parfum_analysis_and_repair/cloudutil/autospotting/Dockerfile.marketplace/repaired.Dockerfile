FROM golang:1.18-alpine as golang
ARG savings_cut

RUN apk add -U --no-cache ca-certificates git make

COPY go.mod go.sum /src/
# Download dependencies
WORKDIR /src
RUN GOPROXY=direct go mod download

COPY . /src

RUN FLAVOR=stable CGO_ENABLED=0 GOPROXY=direct SAVINGS_CUT=$savings_cut make

FROM alpine:latest
COPY LICENSE BINARY_LICENSE THIRDPARTY /
COPY --from=golang /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=golang /src/AutoSpotting .
ENTRYPOINT ["./AutoSpotting"]