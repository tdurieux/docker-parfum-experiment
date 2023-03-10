# Stage 1: Watchman
ARG WATCHMAN_VERSION=4.9.0
FROM jotadrilo/watchman:$WATCHMAN_VERSION AS watchman

# Stage 2: Python
FROM python:3.10.1
ENV PYTHONPATH /code
# This is to print directly to stdout instead of buffering output
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get -y --no-install-recommends install lsb-release && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN sh -c 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -'
RUN apt-get update && apt-get -y --no-install-recommends install postgresql-client-13 gettext && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir poetry==1.1.4 pywatchman==1.4.1

# Install Watchman