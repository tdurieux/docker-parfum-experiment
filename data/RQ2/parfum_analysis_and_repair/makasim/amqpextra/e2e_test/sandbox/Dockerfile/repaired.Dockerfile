FROM golang:1.18

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --no-install-suggests netcat && rm -rf /var/lib/apt/lists/*;

RUN go install github.com/rakyll/gotest@latest