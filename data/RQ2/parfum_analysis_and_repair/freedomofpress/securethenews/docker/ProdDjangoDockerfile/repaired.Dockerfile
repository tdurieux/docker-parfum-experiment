# sha256 as of 2021-07-22
FROM node:14-alpine@sha256:5c33bc6f021453ae2e393e6e20650a4df0a4737b1882d389f17069dc1933fdc5 AS node-assets

# Install npm, making output less verbose
ARG NPM_VER=7.24.1
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install npm@${NPM_VER} -g && npm cache clean --force;

# Workaround to avoid webpack hanging, see:
# https://github.com/webpack/webpack-dev-server/issues/128
ENV UV_THREADPOOL_SIZE 128

# Oddly, node-sass requires both python and make to build bindings
RUN apk add --no-cache paxctl python make g++
RUN paxctl -cm /usr/local/bin/node

COPY ./ /src-files
RUN cd /src-files && ( npm install && npm run build ) && npm cache clean --force;

# sha256 as of 2021-05-07 for 3.9-slim
FROM python@sha256:655f71f243ee31eea6774e0b923b990cd400a0689eff049facd2703e57892447

RUN apt-get update && \
        apt-get install --no-install-recommends -y \
        bash \
        build-essential \
        curl \
        gcc \
        git \
        libjpeg-dev \
        libffi-dev \
        libpq-dev \
        libtiff-dev \
        libssl-dev \
        libz-dev \
        musl-dev \
        netcat-traditional \
        paxctl \
        python3-dev && rm -rf /var/lib/apt/lists/*;

COPY docker/django-start.sh /usr/local/bin
RUN  chmod +x /usr/local/bin/django-start.sh

# Infra will supply this in CI, because it needs to match Kubernetes
ARG USERID
RUN adduser --disabled-password --gecos "" --uid "${USERID?USERID must be supplied}" gcorn

LABEL MAINTAINER="Freedom of the Press Foundation"
LABEL APP="securethenews"

RUN paxctl -cm /usr/local/bin/python
COPY --from=node-assets /src-files/ /django/
# Unfortunately the chown flag in COPY is not
# available in my docker system version :(
RUN find /django -path /django/node_modules -prune -o -print -exec chown gcorn: '{}' \;

WORKDIR /django
RUN pip install --no-cache-dir --require-hashes -r /django/securethenews/requirements.txt

# Really not used in production. Needed for mapped named volume
# permission handling https://github.com/docker/compose/issues/3270
RUN  mkdir /django-media /django-static /django-logs && \
     chown -R gcorn: /django-media && \
     chown -R gcorn: /django-static && \
     chown -R gcorn: /django-logs

RUN mkdir -p /etc/gunicorn && chown -R gcorn: /etc/gunicorn
COPY docker/gunicorn/gunicorn.py /etc/gunicorn/gunicorn.py

RUN mkdir /deploy && \
    chown -R gcorn: /deploy

RUN /django/scripts/version-file.sh

RUN /django/scripts/django-collect-static.sh

EXPOSE 8000
USER gcorn

CMD ["/usr/local/bin/django-start.sh"]
