FROM ubuntu:18.04

# -- Install Pipenv:
RUN apt update && apt install python-pip python3-pip time git -y && pip3 install pipenv

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# -- Install Application into container:
RUN set -ex && mkdir /app

WORKDIR /pipenv
