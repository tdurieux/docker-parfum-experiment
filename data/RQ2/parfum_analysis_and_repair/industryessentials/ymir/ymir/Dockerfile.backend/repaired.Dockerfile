FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG PIP_SOURCE=https://pypi.org/simple

RUN apt-get update \
  && apt-get install --no-install-recommends -y git \
  && apt-get install --no-install-recommends -y vim \
  && apt-get install -y --no-install-recommends python3-pip python3-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir -i ${PIP_SOURCE} --upgrade pip

RUN git config --global core.fileMode false

RUN pip install --no-cache-dir "uvicorn[standard]" gunicorn -i ${PIP_SOURCE}

RUN mkdir -p /data/sharing/
RUN mkdir -p /app_logs/

COPY ./backend/requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt -i ${PIP_SOURCE}

COPY ./command /command
RUN pip3 install --no-cache-dir -U /command -i ${PIP_SOURCE}

COPY ./backend/src /app
WORKDIR /app

COPY ./backend/deploy/git.config /root/.gitconfig


COPY ./backend/deploy/supervisor /app/supervisor

ENV PYTHONPATH=/app/ymir_app:/app/ymir_controller:/app/ymir_viz:/app/common:/app/ymir_monitor:/app/ymir_postman
