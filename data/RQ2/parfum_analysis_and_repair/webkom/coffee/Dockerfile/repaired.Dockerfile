FROM python:3.5

MAINTAINER Abakus Webkom <webkom@abakus.no>

ENV PYTHONPATH /app/
ENV PYTHONUNBUFFERED 1

ENV PORT 8000

RUN mkdir -p /app
COPY . /app/
WORKDIR /app

RUN set -e \
    && curl -f -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get update \
    && apt-get install --no-install-recommends -y git nodejs \
    && apt-get autoremove -y \
    && apt-get clean \
    && pip install --no-cache-dir -U pip \
    && npm install -g npm \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && npm cache clean --force;

RUN set -e \
    && pip install --no-cache-dir -Ur requirements/docker.txt \
    && npm install \
    && npm run build && npm cache clean --force;

ENTRYPOINT ["uwsgi", "--ini", "coffee.ini"]
