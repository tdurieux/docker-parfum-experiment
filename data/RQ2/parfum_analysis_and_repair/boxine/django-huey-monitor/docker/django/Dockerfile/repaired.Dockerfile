# https://hub.docker.com/_/python
FROM python:3.9-slim-buster

# for pip cache:
ENV XDG_CACHE_HOME=/var/cache

ENV PYTHONUNBUFFERED=1

# Install deps
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y postgresql-client-11 python3-pip \
    && rm -rf /var/lib/apt \
    && python3 -m pip install -U pip \
    && pip3 install --no-cache-dir -U poetry psycopg2-binary && rm -rf /var/lib/apt/lists/*;

WORKDIR /django

#COPY huey_monitor ./huey_monitor/
COPY poetry.lock pyproject.toml ./

RUN poetry install --no-root
