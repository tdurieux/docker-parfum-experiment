FROM debian:wheezy

RUN apt-get update && apt-get -y install libfontconfig wget adduser openssl ca-certificates && apt-get clean

RUN wget http://grafanarel.s3.amazonaws.com/builds/grafana_latest_amd64.deb

RUN dpkg -i grafana_latest_amd64.deb

EXPOSE 3000

VOLUME ["/var/lib/grafana"]
VOLUME ["/var/log/grafana"]

ADD grafana.ini /

WORKDIR /usr/share/grafana

ENTRYPOINT ["/usr/sbin/grafana-server", "--config=/grafana.ini", "cfg:default.paths.data=/var/lib/grafana", "cfg:default.paths.logs=/var/log/grafana"]
