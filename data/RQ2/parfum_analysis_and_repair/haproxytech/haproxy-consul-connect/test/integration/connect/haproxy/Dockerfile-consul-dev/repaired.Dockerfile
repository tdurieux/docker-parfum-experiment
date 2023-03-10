FROM golang:1.15.8 AS builder
ARG CONSUL_TAG=master
RUN cd / && \
    git clone https://github.com/hashicorp/consul.git && \
    cd consul && \
    git checkout $CONSUL_TAG && \
    make dev-build

FROM consul:latest
COPY --from=builder /consul/bin/consul /bin/consul