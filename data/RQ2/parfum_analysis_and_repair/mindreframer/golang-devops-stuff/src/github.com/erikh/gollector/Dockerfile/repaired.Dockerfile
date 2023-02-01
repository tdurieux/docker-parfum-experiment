FROM ubuntu
MAINTAINER fart

ADD . /opt/gollector/
RUN apt-get update && apt-get install --no-install-recommends rsyslog curl -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/opt/gollector/docker/dind", "sh", "-c", "rsyslogd -c5 && sleep 5 && /opt/gollector/gollector /opt/gollector/test.json"]
