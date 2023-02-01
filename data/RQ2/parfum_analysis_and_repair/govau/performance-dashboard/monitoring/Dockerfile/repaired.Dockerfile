FROM ubuntu
MAINTAINER  Michael Richardson <michael.richardson@digital.gov.au>

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y wget build-essential && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 && \
chmod +x /usr/bin/confd

RUN wget -q https://repositories.sensuapp.org/apt/pubkey.gpg -O- | apt-key add - && \
echo "deb     http://repositories.sensuapp.org/apt sensu main"  | tee /etc/apt/sources.list.d/sensu.list && \
apt-get update && \
 apt-get -y --no-install-recommends install sensu && rm -rf /var/lib/apt/lists/*;

# Some basic defaults for local development
ENV RABBITMQ_HOST=sensu-server RABBITMQ_PORT=5672 RABBITMQ_USER=sensu RABBITMQ_PASSWORD=sensu RABBITMQ_VHOST=sensu

RUN /opt/sensu/embedded/bin/gem install sensu-plugins-http

ADD files/sensu-conf.d /etc/sensu/conf.d
ADD files/confd /etc/confd
ADD files/go.sh /go.sh

CMD ["/go.sh"]
