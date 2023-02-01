# gcr.io/dl-flow/golang-cmake

FROM golang:1.18-buster
RUN apt-get update && apt-get -y --no-install-recommends install cmake zip && rm -rf /var/lib/apt/lists/*;
RUN go get github.com/axw/gocov/gocov
RUN go get github.com/matm/gocov-html
WORKDIR /go/src/flow
