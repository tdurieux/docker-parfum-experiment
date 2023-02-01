# builder
FROM golang:1.16 AS builder
COPY go.mod /src/
COPY go.sum /src/
RUN cd /src && go mod download
COPY . /src/
RUN cd /src && go build -ldflags '-linkmode "external" --extldflags "-static"' cmd/ipasd/ipasd.go

# runtime