FROM grafana/grafana:7.1.5

RUN grafana-cli plugins install grafana-influxdb-flux-datasource 5.4.1

COPY grafana-provisioning/ /etc/grafana/provisioning