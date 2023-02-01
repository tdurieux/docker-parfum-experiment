FROM golang:1.13

RUN apt update && apt-get install --no-install-recommends -y libzmq3-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /go




