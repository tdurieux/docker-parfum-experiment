FROM python:3.8.1-slim

LABEL maintainer="webteam@rheinwerk-verlag.de"

RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install --no-install-recommends -y libpq-dev python3-pip \
 && pip install --no-cache-dir -U pip \
 && pip install --no-cache-dir pganonymize psycopg2-binary \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
