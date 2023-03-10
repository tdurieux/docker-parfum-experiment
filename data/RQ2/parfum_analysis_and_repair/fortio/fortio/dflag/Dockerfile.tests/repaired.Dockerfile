FROM golang as builder

WORKDIR /build
COPY go.mod .
COPY go.sum .
RUN go mod download
ADD . /build/
RUN go test -v ./dflag/...