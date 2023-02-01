FROM redislabs/redisearch:1.6.15 as redisearch
FROM redislabs/rejson:1.0.8 as rejson

FROM redis:5

# Install RediSearch 1.6.15
COPY --from=redisearch /usr/lib/redis/modules/ /usr/lib/redis/modules/

# Install RedisJSON 1.0.8
COPY --from=rejson /usr/lib/redis/modules/ /usr/lib/redis/modules/

COPY redis.conf /etc/redis.conf

ENTRYPOINT [ "redis-server", "/etc/redis.conf" ]
