FROM rabbitmq:3.7-management
RUN mkdir -p /etc/rabbitmq/
COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
COPY enabled_plugins /etc/rabbitmq/enabled_plugins