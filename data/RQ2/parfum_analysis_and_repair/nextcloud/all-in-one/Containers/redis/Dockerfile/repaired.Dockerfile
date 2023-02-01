# From https://github.com/docker-library/redis/blob/master/6.2/alpine/Dockerfile
FROM redis:6.2.7-alpine

RUN apk add --update --no-cache openssl bash

COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh

# Give root a random password