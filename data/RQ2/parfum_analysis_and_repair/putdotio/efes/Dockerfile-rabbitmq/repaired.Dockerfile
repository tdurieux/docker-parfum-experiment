FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install rabbitmq-server && rm -rf /var/lib/apt/lists/*;

ARG RABBITMQ_USER=efes
ARG RABBITMQ_PASS=123

ENV RABBITMQ_NODENAME=efes@localhost

RUN rabbitmq-plugins enable --offline rabbitmq_management
EXPOSE 15671 15672

ADD docker-init-rabbitmq.sh /tmp/
RUN ["bash", "/tmp/docker-init-rabbitmq.sh"]

ENTRYPOINT ["rabbitmq-server", "--hostname", "localhost"]
