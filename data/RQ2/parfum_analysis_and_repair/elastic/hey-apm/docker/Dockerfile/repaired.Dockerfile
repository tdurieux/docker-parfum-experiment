# from .. run: docker build -t hey-apm -f docker/Dockerfile .
FROM golang:1.14
RUN useradd hey

WORKDIR /build
COPY go.* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o hey-apm .

FROM scratch
MAINTAINER Elastic APM Team <docker@elastic.co>

# https://github.com/golang/go/blob/release-branch.go1.14/src/crypto/x509/root_linux.go