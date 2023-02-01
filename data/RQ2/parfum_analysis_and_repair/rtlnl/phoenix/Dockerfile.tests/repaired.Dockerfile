FROM golang:1.13

ENV GO111MODULE=on

WORKDIR /app

RUN apt-get update && \
    apt-get install --no-install-recommends -y bzr && rm -rf /var/lib/apt/lists/*;

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .
