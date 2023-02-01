FROM grafana/promtail:2.3.0

RUN apt-get update && apt-get install --no-install-recommends -y bash bc coreutils curl dumb-init jq net-tools procps python sysstat vim && rm -rf /var/lib/apt/lists/*;

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
logcli-linux-arm \
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
websocat_arm-linux-static \
/weatherflow-collector/

WORKDIR /weatherflow-collector

RUN chmod a+x *.sh

RUN chmod +x logcli-linux-arm websocat_arm-linux-static

RUN mv logcli-linux-arm logcli
RUN mv websocat_arm-linux-static websocat

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/weatherflow-collector/start.sh"]