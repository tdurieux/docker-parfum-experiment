FROM golang:1.18-buster AS builder

RUN apt update && apt upgrade -y && apt install --no-install-recommends iptables -y && rm -rf /var/lib/apt/lists/*;

RUN git clone --single-branch --branch v1.9.3 https://github.com/coredns/coredns.git /coredns

WORKDIR /coredns

RUN make gen
RUN make

RUN mkdir -p plugin/nodecache
RUN echo 'nodecache:nodecache' >> /coredns/plugin.cfg

COPY *.go /coredns/plugin/nodecache/
RUN make
RUN chmod 0755 /coredns/coredns

FROM alpine:3.15
RUN apk add --no-cache iptables

COPY --from=builder /coredns/coredns /
COPY Corefile /

EXPOSE 5300

ENTRYPOINT ["/coredns"]
