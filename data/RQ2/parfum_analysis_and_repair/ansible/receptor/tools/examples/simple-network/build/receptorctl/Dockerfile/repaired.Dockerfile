FROM alpine

WORKDIR /opt

RUN set -x \
    && apk add --no-cache php py3-pip git bash \
    && git clone --depth 1 https://github.com/ansible/receptor.git \
    && pip3 install --no-cache-dir -e ./receptor/receptorctl

WORKDIR /app

CMD ["php", "-S", "0.0.0.0:8080"]
