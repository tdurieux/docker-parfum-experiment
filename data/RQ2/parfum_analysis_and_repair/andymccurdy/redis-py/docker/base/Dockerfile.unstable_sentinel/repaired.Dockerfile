# produces redisfab/redis-py-sentinel:unstable
FROM ubuntu:bionic as builder
RUN apt-get update && apt-get install --no-install-recommends -y build-essential git && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

RUN mkdir /build
WORKDIR /build
RUN git clone https://github.com/redis/redis
WORKDIR /build/redis
RUN make

FROM ubuntu:bionic as runner
COPY --from=builder /build/redis/src/redis-server /usr/bin/redis-server
COPY --from=builder /build/redis/src/redis-cli /usr/bin/redis-cli
COPY --from=builder /build/redis/src/redis-sentinel /usr/bin/redis-sentinel

CMD ["redis-sentinel", "/sentinel.conf"]
