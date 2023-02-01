FROM golang:1.13

WORKDIR /go/src/app
COPY . .

RUN apt-get update -y && apt-get install --no-install-recommends -y libyara-dev pkg-config && rm -rf /var/lib/apt/lists/*;

RUN make deps
RUN make linux

ENTRYPOINT ./build/linux/phishdetect-node --host 0.0.0.0
