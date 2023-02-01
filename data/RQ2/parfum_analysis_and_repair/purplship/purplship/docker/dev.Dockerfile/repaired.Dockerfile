# The base image compilation
FROM python:3.8-slim AS compile-image
RUN python -m venv /karrio/venv
ENV PATH="/karrio/venv/bin:$PATH"
COPY . /karrio/app/
RUN cd /karrio/app && \
    pip install --no-cache-dir -r requirements.dev.txt --upgrade && \
    pip install --no-cache-dir -r requirements.server.dev.txt


# The runtime image
FROM python:3.8-slim AS build-image

RUN useradd -m karrio -d /karrio
USER karrio
COPY --chown=karrio:karrio --from=compile-image /karrio/ /karrio/
RUN mkdir -p /karrio/.karrio

WORKDIR /karrio/app

# Make sure we use the virtualenv:
ENV PATH="/karrio/venv/bin:$PATH"
