FROM python:3.7-slim

WORKDIR /usr/app

RUN apt update \
  && apt install --no-install-recommends -y openssh-server software-properties-common \
  && pip install --no-cache-dir ansible && rm -rf /var/lib/apt/lists/*;

