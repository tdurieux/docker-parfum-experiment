FROM golang:1.9-alpine3.6 as builder

ENV PILOT_DIR /go/src/github.com/AliyunContainerService/log-pilot
ARG GOOS=linux
ARG GOARCH=arm64
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    set -ex && apk add --no-cache make git gcc g++
WORKDIR $PILOT_DIR
COPY . $PILOT_DIR
RUN go install

# 注意alpine mul libc 与 gnc libc
FROM alpine:3.6
COPY assets/glibc/arm64/glibc-2.23-r3.apk /tmp/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache python && \
    apk add --no-cache ruby-json ruby-irb && \
    apk add --no-cache build-base ruby-dev && \
    apk add --no-cache python && \
    apk add --no-cache lsof && \
    apk add --no-cache ca-certificates wget && \
    gem install fluentd -v 1.2.6 --no-ri --no-rdoc && \
    gem install fluent-plugin-elasticsearch -v ">=2.0.0" --no-ri --no-rdoc && \
    gem install gelf -v "~> 3.0.0" --no-ri --no-rdoc && \
    gem install aliyun_sls_sdk -v ">=0.0.9" --no-ri --no-rdoc && \
    gem install remote_syslog_logger -v ">=1.0.1" --no-ri --no-rdoc && \
    gem install fluent-plugin-remote_syslog -v ">=0.2.1" --no-ri --no-rdoc && \
    gem install fluent-plugin-kafka --no-ri --no-rdoc && \
    gem install fluent-plugin-flowcounter --no-ri --no-rdoc && \
    apk del build-base ruby-dev && \
    rm -rf /root/.gem && \
    apk add --no-cache curl openssl && \
    apk add --no-cache --allow-untrusted /tmp/glibc-2.23-r3.apk && \
    ln -s /lib/ld-musl-aarch64.so.1   /lib/ld-linux-aarch64.so.1 && \
    rm -rf /tmp/glibc-2.23-r3.apk

COPY --from=builder /go/bin/log-pilot /pilot/pilot
COPY assets/entrypoint assets/fluentd/ assets/healthz /pilot/
RUN mkdir -p /etc/fluentd && \
    mv /pilot/plugins /etc/fluentd/ && \
    chmod +x /pilot/pilot /pilot/entrypoint /pilot/healthz /pilot/config.fluentd

HEALTHCHECK CMD /pilot/healthz

VOLUME /etc/fluentd/conf.d
VOLUME /pilot/pos
WORKDIR /pilot/
ENV PILOT_TYPE=fluentd
ENTRYPOINT ["/pilot/entrypoint"]
