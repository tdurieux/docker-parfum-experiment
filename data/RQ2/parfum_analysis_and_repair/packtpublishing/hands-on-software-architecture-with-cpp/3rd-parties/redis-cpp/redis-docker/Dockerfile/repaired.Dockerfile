FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN sed -i 's/^bind 127\.0\.0\.1 \:\:1$/bind 0\.0\.0\.0/g' /etc/redis/redis.conf
RUN sed -i 's/^daemonize yes$/daemonize no/g' /etc/redis/redis.conf

CMD /usr/bin/redis-server /etc/redis/redis.conf
