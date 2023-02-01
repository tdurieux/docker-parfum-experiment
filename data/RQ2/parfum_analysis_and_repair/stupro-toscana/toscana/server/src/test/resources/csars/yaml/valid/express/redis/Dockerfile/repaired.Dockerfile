# This image is used to test the functionality of the scripts for the
# Redis node
FROM ubuntu:16.04
WORKDIR /redis
COPY *.sh /redis/
COPY redis.conf /redis/
RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN ./install_redis.sh
EXPOSE 6379
ENTRYPOINT ./start_redis.sh
