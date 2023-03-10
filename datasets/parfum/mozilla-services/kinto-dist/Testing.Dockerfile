# syntax=docker/dockerfile:1.3

# This name comes from the docker-compose yml file that defines a name
# for the "web" container's image.
FROM kinto:build

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH="/app:$PYTHONPATH"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl wget

RUN pip install --upgrade pip
COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY tests .
COPY kinto-remote-settings/tests ./kinto-remote-settings/tests

ENTRYPOINT ["/bin/bash", "/app/run.sh"]
