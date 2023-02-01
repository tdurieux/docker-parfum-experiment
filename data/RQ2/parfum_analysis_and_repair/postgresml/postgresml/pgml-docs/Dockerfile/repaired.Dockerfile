FROM python:3.10
MAINTAINER docker@postgresml.com

COPY requirements.txt /app/requirements.txt
WORKDIR /app

RUN pip install --no-cache-dir -U pip && \
	pip install --no-cache-dir -r requirements.txt

COPY . /app
WORKDIR /app

ENTRYPOINT ["/bin/bash", "/app/docker/entrypoint.sh"]
