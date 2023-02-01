FROM ubuntu:trusty
MAINTAINER John Dilts <john.dilts@enstratius.com>

RUN apt-get update && apt-get install --no-install-recommends -y curl wget openssl redis-server supervisor && rm -rf /var/lib/apt/lists/*;

ADD https://raw.githubusercontent.com/jbrien/sensu-docker/compose/support/install-sensu.sh /tmp/
RUN chmod +x /tmp/install-sensu.sh
RUN /tmp/install-sensu.sh

ADD redis-run.sh /tmp/
ADD supervisor.conf /etc/supervisor/conf.d/sensu.conf

CMD /tmp/redis-run.sh
