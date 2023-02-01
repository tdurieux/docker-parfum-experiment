FROM python:3.10
MAINTAINER docker@postgresml.com

RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev curl postgresql-client-13 tzdata && rm -rf /var/lib/apt/lists/*; ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC


COPY requirements.txt /app/requirements.txt
WORKDIR /app

RUN pip install --no-cache-dir -U pip && \
	pip install --no-cache-dir -r requirements.txt

COPY . /app
WORKDIR /app

ENTRYPOINT ["/bin/bash", "/app/docker/entrypoint.sh"]
