FROM --platform=linux/%%BALENA_ARCH%% grafana/grafana:master

COPY ./datasources/datasources.yaml /etc/grafana/provisioning/datasources/datasources.yaml