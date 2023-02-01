FROM python:3.9-slim-bullseye

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Install prerequisites
RUN apt-get update && apt-get --yes --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;

# Provide sources
COPY . /app

# Install package
WORKDIR /app
RUN python setup.py install
