FROM        ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
EXPOSE      6379
ENTRYPOINT  ["/usr/bin/redis-server"]
