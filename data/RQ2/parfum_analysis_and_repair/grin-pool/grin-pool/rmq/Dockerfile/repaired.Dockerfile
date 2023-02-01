FROM rabbitmq

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install \
        python && rm -rf /var/lib/apt/lists/*;

COPY rabbitmqadmin /
COPY definitions.json /etc/rabbitmq/
COPY definitions.json /
COPY import_config.sh /
COPY entrypoint.sh /

RUN rabbitmq-plugins enable rabbitmq_management
