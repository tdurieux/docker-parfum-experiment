FROM golang:1.16

RUN go get gotest.tools/gotestsum
RUN mkdir /root/.ssh
COPY id_rsa /root/.ssh/semaphore_cache_key

WORKDIR /app