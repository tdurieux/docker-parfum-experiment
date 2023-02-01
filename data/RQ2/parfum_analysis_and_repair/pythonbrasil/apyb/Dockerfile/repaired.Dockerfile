FROM python:3.7-slim-buster
ENV PYTHONUNBUFFERED 1
VOLUME /src
WORKDIR /src
ADD requirements.txt /src/
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y gcc libpq-dev && \
    apt-get clean && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get remove -y gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*
ADD . /src/
