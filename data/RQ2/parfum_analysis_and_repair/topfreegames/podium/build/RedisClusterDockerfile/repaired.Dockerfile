FROM redis:6.2.1-alpine

RUN apk --update --no-cache add bash

COPY ./build/package/redis_cluster.conf /redis_model.conf
COPY ./build/package/start_redis.sh /start_redis.sh

ENTRYPOINT [ "/start_redis.sh" ]