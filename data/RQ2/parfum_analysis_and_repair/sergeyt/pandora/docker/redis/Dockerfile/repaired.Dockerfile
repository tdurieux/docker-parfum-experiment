FROM redis:5.0.9-alpine

RUN apk add --no-cache --update curl \
    && rm -rf /var/cache/apk/*

# COPY redis.conf /usr/local/etc/redis/redis.conf
# CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
CMD [ "redis-server" ]
