FROM rabbitmq:3.9-management

RUN apt-get update && \
    apt-get install --no-install-recommends wget -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

USER rabbitmq

# ENV RABBITMQ_DEFAULT_VHOST=test RABBITMQ_DEFAULT_USER=guest

RUN cd /opt/rabbitmq/plugins && \
    wget https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.9.0/rabbitmq_delayed_message_exchange-3.9.0.ez && \
    rabbitmq-plugins enable rabbitmq_delayed_message_exchange
