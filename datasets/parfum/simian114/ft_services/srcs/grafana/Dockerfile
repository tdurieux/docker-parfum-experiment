FROM alpine:latest

RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --no-cache

COPY srcs/dashboards /var/lib/grafana/dashboards/
COPY srcs/provisioning/dashboards/dashboards.yaml /usr/share/grafana/conf/provisioning/dashboards/
COPY srcs/provisioning/datasources/influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/

EXPOSE 3000

ENTRYPOINT ["/usr/sbin/grafana-server", "--config=/etc/grafana/grafana.ini", "--homepath=/usr/share/grafana"]
