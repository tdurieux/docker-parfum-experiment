FROM grafana/grafana:7.3.7
ENV GF_PATHS_CONFIG /etc/grafana/config.ini
ADD ./provisioning /etc/grafana/provisioning
ADD ./config.ini $GF_PATHS_CONFIG
ADD ./dashboards /var/lib/grafana/dashboards
RUN grafana-cli plugins install raintank-worldping-app
RUN grafana-cli plugins install jdbranham-diagram-panel