FROM ubuntu:20.04

RUN apt-get update && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get -y --no-install-recommends install nodejs && \
    npm install -g yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Install build dependencies
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

RUN apt-get update && apt-get -y --no-install-recommends install git dpkg fakeroot rpm zip build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
