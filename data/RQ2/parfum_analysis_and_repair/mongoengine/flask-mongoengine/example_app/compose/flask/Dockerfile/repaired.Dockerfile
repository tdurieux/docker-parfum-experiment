FROM python:3.7-slim as dev

ENV PYTHONUNBUFFERED 1
RUN apt-get update && \
    apt-get install git -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*
RUN groupadd -r flask && useradd -r -g flask flask
COPY --chown=flask . /flask_mongoengine
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -e /flask_mongoengine[toolbar,wtf]
WORKDIR /flask_mongoengine
