FROM zabbix/zabbix-server-mysql:alpine-latest

USER root

RUN apk update && \
    apk add --no-cache py-pip git

RUN set -x && \
  pip install --no-cache-dir pip --upgrade && \
  pip install --no-cache-dir git+https://github.com/alerta/zabbix-alerta
