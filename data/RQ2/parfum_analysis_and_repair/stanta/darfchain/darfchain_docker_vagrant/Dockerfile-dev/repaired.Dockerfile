FROM python:3.6
LABEL maintainer "dev@bigchaindb.com"

RUN apt-get update \
    && apt-get install --no-install-recommends -y vim \
    && pip install --no-cache-dir -U pip \
    && pip install --no-cache-dir pynacl \
    && apt-get autoremove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV BIGCHAINDB_SERVER_BIND 0.0.0.0:9984
ENV BIGCHAINDB_WSSERVER_HOST 0.0.0.0
ENV BIGCHAINDB_WSSERVER_SCHEME ws

ENV BIGCHAINDB_WSSERVER_ADVERTISED_HOST 0.0.0.0
ENV BIGCHAINDB_WSSERVER_ADVERTISED_SCHEME ws

ARG backend

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
COPY . /usr/src/app/
WORKDIR /usr/src/app
RUN pip install --no-cache-dir -e .[dev]
RUN bigchaindb -y configure "$backend"
