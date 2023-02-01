FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y gnupg2 wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | apt-key add -

COPY apt/sources.list.d/bintray.rabbitmq.list /etc/apt/sources.list.d/bintray.rabbitmq.list
COPY apt/preferences.d/erlang                 /etc/apt/preferences.d/erlang

RUN apt-get update -y

RUN apt-get upgrade -y && \
    apt-get install --no-install-recommends -y rabbitmq-server && rm -rf /var/lib/apt/lists/*;

COPY docker-entrypoint.sh /
COPY certificates/*.pem /etc/rabbitmq/
COPY rabbitmq.conf      /etc/rabbitmq/rabbitmq.conf

ENTRYPOINT /docker-entrypoint.sh

EXPOSE 5671 5672 15672
