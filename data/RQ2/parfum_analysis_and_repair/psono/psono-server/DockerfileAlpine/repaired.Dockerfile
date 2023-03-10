# PSONO Dockerfile for Alpine
FROM psono-docker.jfrog.io/python:3.10.4-alpine3.16

LABEL maintainer="Sascha Pfeiffer <sascha.pfeiffer@psono.com>"
COPY psono/static/email /var/www/html/static/email
COPY . /root/
ENV PYTHONUNBUFFERED True
WORKDIR /root

RUN apk upgrade && \
    mkdir -p /root/.pip && \
    echo '[global]' >> /root/.pip/pip.conf && \
    echo 'index-url = https://psono.jfrog.io/psono/api/pypi/pypi/simple' >> /root/.pip/pip.conf && \
    apk add \
        ca-certificates \
        curl \
        postgresql-dev && \
    apk add --virtual .build-deps \
        build-base \
        libffi-dev \
        linux-headers && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir uwsgi && \
    mkdir -p /root/.psono_server && \
    cp /root/configs/mainconfig/settings.yaml /root/.psono_server/settings.yaml && \
    sed -i /root/.psono_server/settings.yaml \
        -e "s/YourPostgresDatabase/postgres/g " \
        -e "s/YourPostgresUser/postgres/g" \
        -e "s/YourPostgresHost/postgres/g" \
        -e "s/YourPostgresPort/5432/g" \
        -e "s,path/to/psono-server,root,g" && \
    apk del .build-deps && \
    rm -Rf \
        /root/.cache \
        /var/cache/apk/*


HEALTHCHECK --interval=2m --timeout=3s \
	CMD curl -f http://localhost/healthcheck/ || exit 1

EXPOSE 80

CMD ["/bin/sh", "/root/configs/docker/cmd.sh"]
