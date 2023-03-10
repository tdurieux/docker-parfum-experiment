FROM runnable/base:1.0.0

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r rabbitmq && useradd -r -d /var/lib/rabbitmq -m -g rabbitmq rabbitmq

# Install Erlang

# Add the officially endorsed Erlang debian repository:
# See:
#  - http://www.erlang.org/download.html
#  - https://www.erlang-solutions.com/resources/download.html
RUN set -ex; \
  key='434975BD900CCBE4F7EE1B1ED208507CA14F4FCA'; \
  export GNUPGHOME="$(mktemp -d)"; rm -rf -d \
  gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/erlang-solutions.gpg; \
  rm -r "$GNUPGHOME"; \
  apt-key list
RUN echo 'deb http://packages.erlang-solutions.com/debian jessie contrib' > /etc/apt/sources.list.d/erlang.list

# install Erlang
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    erlang-asn1 \
    erlang-base-hipe \
    erlang-crypto \
    erlang-eldap \
    erlang-inets \
    erlang-mnesia \
    erlang-nox \
    erlang-os-mon \
    erlang-public-key \
    erlang-ssl \
    erlang-xmerl \
  && rm -rf /var/lib/apt/lists/*

# Install RabbitMQ 3.6

# get logs to stdout (thanks @dumbbell for pushing this upstream! :D)
ENV RABBITMQ_LOGS=- RABBITMQ_SASL_LOGS=-
# https://github.com/rabbitmq/rabbitmq-server/commit/53af45bf9a162dec849407d114041aad3d84feaf

# http://www.rabbitmq.com/install-debian.html
# "Please note that the word testing in this line refers to the state of our release of RabbitMQ, not any particular Debian distribution."
RUN set -ex; \
  key='0A9AF2115F4687BD29803A206B73A36E6026DFCA'; \
  export GNUPGHOME="$(mktemp -d)"; rm -rf -d \
  gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/rabbitmq.gpg; \
  rm -r "$GNUPGHOME"; \
  apt-key list
RUN echo 'deb http://www.rabbitmq.com/debian testing main' > /etc/apt/sources.list.d/rabbitmq.list

ENV RABBITMQ_VERSION 3.6.6
ENV RABBITMQ_DEBIAN_VERSION 3.6.6-1

RUN apt-get update && apt-get install -y --no-install-recommends \
    rabbitmq-server=$RABBITMQ_DEBIAN_VERSION \
  && rm -rf /var/lib/apt/lists/*

# /usr/sbin/rabbitmq-server has some irritating behavior, and only exists to "su - rabbitmq /usr/lib/rabbitmq/bin/rabbitmq-server ..."
ENV PATH /usr/lib/rabbitmq/bin:$PATH

# set home so that any `--user` knows where to put the erlang cookie
ENV HOME /var/lib/rabbitmq

RUN mkdir -p /var/lib/rabbitmq /etc/rabbitmq \
  && echo '[ { rabbit, [ { loopback_users, [ ] } ] } ].' > /etc/rabbitmq/rabbitmq.config \
  && chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq \
  && chmod -R 777 /var/lib/rabbitmq /etc/rabbitmq

# add a symlink to the .erlang.cookie in /root so we can "docker exec rabbitmqctl ..." without gosu
RUN ln -sf /var/lib/rabbitmq/.erlang.cookie /root/

RUN ln -sf /usr/lib/rabbitmq/lib/rabbitmq_server-$RABBITMQ_VERSION/plugins /plugins

# Enable Management Console
RUN rabbitmq-plugins enable --offline rabbitmq_management
EXPOSE 15672

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 4369 5671 5672 25672
CMD ["rabbitmq-server"]
