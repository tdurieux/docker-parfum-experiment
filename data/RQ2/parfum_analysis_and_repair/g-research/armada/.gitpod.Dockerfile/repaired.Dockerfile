FROM golang:1.16.5-buster
USER root
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    && rm -rf /var/lib/apt/lists/*