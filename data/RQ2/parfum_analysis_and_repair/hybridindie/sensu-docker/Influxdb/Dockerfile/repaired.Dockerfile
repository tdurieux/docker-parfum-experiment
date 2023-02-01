FROM ubuntu:trusty
MAINTAINER John Dilts <john.dilts@enstratius.com>

RUN apt-get update && apt-get install --no-install-recommends -y wget curl git-core supervisor && rm -rf /var/lib/apt/lists/*;

RUN wget https://s3.amazonaws.com/influxdb/influxdb_0.8.8_amd64.deb
RUN dpkg -i influxdb_0.8.8_amd64.deb

ADD https://raw.githubusercontent.com/jbrien/sensu-docker/compose/support/install-sensu.sh /tmp/
RUN chmod +x /tmp/install-sensu.sh
RUN /tmp/install-sensu.sh

ADD influxdb-run.sh /tmp/influxdb-run.sh

ADD supervisor.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8083
EXPOSE 8086

CMD ["/tmp/influxdb-run.sh"]
