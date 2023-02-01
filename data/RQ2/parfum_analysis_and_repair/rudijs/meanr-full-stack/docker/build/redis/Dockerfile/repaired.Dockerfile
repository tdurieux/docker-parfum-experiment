FROM        ubuntu:12.10
RUN apt-get update && apt-get -y --no-install-recommends install redis-server && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT  ["/usr/bin/redis-server"]