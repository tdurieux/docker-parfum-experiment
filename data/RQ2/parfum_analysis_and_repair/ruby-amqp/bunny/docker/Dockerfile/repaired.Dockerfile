FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y gnupg2 wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | apt-key add -

COPY apt/sources.list.d/bintray.rabbitmq.list /etc/apt/sources.list.d/bintray.rabbitmq.list
COPY apt/preferences.d/erlang                 /etc/apt/preferences.d/erlang

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install --no-install-recommends -y erlang-base \
                       erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
                       erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
                       erlang-runtime-tools erlang-snmp erlang-ssl \
                       erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y rabbitmq-server && rm -rf /var/lib/apt/lists/*;

COPY docker-entrypoint.sh /

ENTRYPOINT /docker-entrypoint.sh

EXPOSE 5671 5672 15672
