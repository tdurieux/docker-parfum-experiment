FROM debian:bullseye-20210927-slim

RUN apt-get update && \
  apt-get install --no-install-recommends -y rsync && \
  rm -rf /var/lib/apt/lists/*
