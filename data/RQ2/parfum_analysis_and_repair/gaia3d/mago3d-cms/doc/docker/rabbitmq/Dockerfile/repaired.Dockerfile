FROM rabbitmq:3.8.9-management

COPY definitions.json /etc/rabbitmq/

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
