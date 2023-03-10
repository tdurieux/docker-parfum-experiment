FROM ubuntu:latest

RUN apt-get update && apt-get -qy --no-install-recommends install curl mysql-client && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /usr/local/bin/wait-for-it \
    && chmod +x /usr/local/bin/wait-for-it

COPY . /orders

COPY docker-entrypoint.sh /usr/local/bin
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]