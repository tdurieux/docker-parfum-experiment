FROM crystallang/crystal:0.27.2

WORKDIR /usr/src/app

COPY shard.yml ./
COPY spec spec
COPY src src

RUN shards build --release --no-debug

CMD bin/app -w $(nproc) -b 0.0.0.0
