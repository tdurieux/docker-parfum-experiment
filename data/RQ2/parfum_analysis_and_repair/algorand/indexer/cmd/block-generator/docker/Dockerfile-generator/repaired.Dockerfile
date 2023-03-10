FROM golang:1.17.9-alpine

# Build and run the block generator

RUN mkdir /work
WORKDIR /work
ADD . ./
WORKDIR /work/cmd/block-generator
RUN go build
RUN ls
RUN mkdir /config
RUN cp test_config.yml /config/config.yml
CMD ["/bin/sh", "-c", "./block-generator daemon --port 11111 --config /config/config.yml"]