# This Dockerfile is used when running locally using docker-compose for Acceptance Testing.

FROM azul/zulu-openjdk:13.0.1

LABEL maintainer="dev@redotter.sg"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    netcat \
    socat \
    curl \
 && rm -rf /var/lib/apt/lists/*

COPY script/start.sh /start.sh
COPY script/wait.sh /wait.sh

# test.yaml is copied as config.yaml for AT.