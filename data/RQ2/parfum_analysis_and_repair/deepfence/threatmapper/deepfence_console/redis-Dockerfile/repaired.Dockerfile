FROM redis:6.2.6-alpine3.15

MAINTAINER Deepfence Inc
LABEL deepfence.role=system

ENV DF_PROG_NAME="redis1" \
    REDIS_DB_NUMBER=0

COPY redis.conf /usr/local/bin/
COPY startRedis.sh /usr/local/bin/
COPY initializeRedis.sh /usr/local/bin/
RUN apk add --no-cache bash curl \
    && chmod 755 /usr/local/bin/startRedis.sh /usr/local/bin/initializeRedis.sh \
    && rm -rf /var/cache/apk/*
ENTRYPOINT ["/usr/local/bin/startRedis.sh"]
EXPOSE 6379
CMD ["redis-server"]