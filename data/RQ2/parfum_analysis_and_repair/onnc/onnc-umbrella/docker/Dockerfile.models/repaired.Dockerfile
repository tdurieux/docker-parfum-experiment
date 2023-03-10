FROM ubuntu:18.04

RUN groupadd --gid 1000 models \
    && useradd --uid 1000 --gid models --shell /bin/bash --create-home models --home-dir /models/ \
    && mkdir -p /etc/sudoers.d \
    && echo 'models ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers.d/models \
    && chmod 440 /etc/sudoers.d/models

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        sudo \
    && rm -rf /var/lib/apt/lists/*

USER models

WORKDIR /models
RUN sudo chown models:models /models

COPY --chown=models:models ./ ./