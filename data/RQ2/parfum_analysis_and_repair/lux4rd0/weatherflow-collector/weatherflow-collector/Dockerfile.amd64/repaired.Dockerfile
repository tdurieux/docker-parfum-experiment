FROM grafana/promtail:2.2.1

RUN apt-get update && apt-get install --no-install-recommends -y bc curl dumb-init bash python procps coreutils sysstat vim net-tools && rm -rf /var/lib/apt/lists/*;

RUN mkdir /weatherflow-collector
RUN mkdir /weatherflow-collector/export

COPY exec-health-check.sh \
exec-host-performance.sh \
exec-local-udp.sh \
exec-remote-forecast.sh \
exec-remote-import.sh \
exec-remote-rest.sh \
exec-remote-socket.sh \
health_check.sh \
jq \
logcli-linux-amd64 \
loki-config.yml \
start-health-check.sh \
start-host-performance.sh \
start-local-udp.sh \
start-remote-export.sh \
start-remote-forecast.sh \
start-remote-import.sh \
start-remote-rest.sh \
start-remote-socket.sh \
start.sh \
weatherflow-collector_details.sh \
weatherflow-listener.py \
websocat_amd64-linux-static \
/weatherflow-collector/

COPY jq /usr/bin/

WORKDIR /weatherflow-collector

RUN chmod a+x *.sh

RUN chmod +x logcli-linux-amd64 websocat_amd64-linux-static

RUN chmod +x /usr/bin/jq

RUN mv logcli-linux-amd64 logcli
RUN mv websocat_amd64-linux-static websocat

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/weatherflow-collector/start.sh"]
