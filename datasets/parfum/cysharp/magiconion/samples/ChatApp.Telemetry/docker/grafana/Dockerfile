FROM grafana/grafana:7.3.2-ubuntu
COPY ["./docker/grafana/download_dashboards.sh", "/etc/grafana/download_dashboards.sh"]
RUN mkdir -p /var/tmp/grafana/dashboards/default && /bin/sh /etc/grafana/download_dashboards.sh
