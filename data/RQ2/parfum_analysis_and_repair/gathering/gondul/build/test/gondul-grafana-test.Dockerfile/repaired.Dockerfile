FROM grafana/grafana:4.0.0-beta2
ENV GF_SERVER_ROOT_URL http://gondul.gathering.org/grafana/
ENV GF_METRICS_GRAPHITE_ADDRESS graphite:2003
ENV GF_METRICS_GRAPHITE_PREFIX grafana.%(instance_name)s.
ENV GF_DATABASE_TYPE postgres
ENV GF_DATABASE_HOST cryptolocker.tg17.gathering.org:5432
ENV GF_DATABASE_NAME grafana
ENV GF_DATABASE_USER grafana
ENV GF_DATABASE_PASSWORD grafana
ENV GF_DATABASE_SSL_MODE require
ENV GF_AUTH_PROXY_ENABLED true
ENV GF_AUTH_DISABLE_LOGIN_FORM true
ENV GF_EXTERNAL_IMAGE_STORAGE_PROVIDER internal