FROM gcc:10 as builder

COPY . /nanomq

RUN apt update && apt install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

WORKDIR /nanomq/build

RUN cmake -DNOLOG=1 .. && make install

FROM debian:10

COPY --from=builder /nanomq/build/nanomq /usr/local/nanomq
COPY deploy/docker/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

WORKDIR /usr/local/nanomq

RUN ln -s /usr/local/nanomq/nanomq /usr/bin/nanomq

RUN apt update && apt install --no-install-recommends -y libatomic1 && rm -rf /var/lib/apt/lists/*;

EXPOSE 1883

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

CMD ["--url", "nmq-tcp://0.0.0.0:1883"]
