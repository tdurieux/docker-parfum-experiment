FROM ubuntu:latest

RUN apt-get update && apt-get -qy --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

COPY . /trades

COPY docker-entrypoint.sh /usr/local/bin
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]