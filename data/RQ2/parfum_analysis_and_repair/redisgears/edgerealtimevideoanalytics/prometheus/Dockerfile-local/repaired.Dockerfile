FROM prom/prometheus:v2.8.0

ADD ./config-local.yml /etc/prometheus/config.yml

CMD [ "--config.file=/etc/prometheus/config.yml" ]