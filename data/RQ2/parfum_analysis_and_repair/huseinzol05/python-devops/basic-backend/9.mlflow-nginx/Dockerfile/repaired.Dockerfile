FROM ubuntu:16.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    python3-wheel \
    nginx && rm -rf /var/lib/apt/lists/*;

ADD . /code

WORKDIR /code

RUN pip3 install --no-cache-dir mlflow

RUN rm /etc/nginx/sites-enabled/default

RUN cp mlflow-config.conf /etc/nginx/conf.d/

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
