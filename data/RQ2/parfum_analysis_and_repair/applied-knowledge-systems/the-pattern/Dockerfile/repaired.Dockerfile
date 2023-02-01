FROM redislabs/redisai:edge-cpu-bionic AS builder
FROM redislabs/rgcluster:edge
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libgomp1 && rm -rf /var/lib/apt/lists/*;
ENV REDIS_MODULES /usr/lib/redis/modules
ENV LD_LIBRARY_PATH $REDIS_MODULES

RUN mkdir -p $REDIS_MODULES/

COPY --from=builder /usr/lib/redis/modules/ $REDIS_MODULES/

COPY --from=builder /var/opt/redislabs/artifacts/ /var/opt/redislabs/artifacts

WORKDIR /cluster

CMD []