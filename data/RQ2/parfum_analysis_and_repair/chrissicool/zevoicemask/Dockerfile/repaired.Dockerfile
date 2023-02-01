FROM ubuntu:latest
LABEL maintainer="Christian Ludwig <chrissicool@gmail.com>"

WORKDIR /zevoicemask
ARG UID

RUN apt-get update && apt-get install --no-install-recommends -y git python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;
RUN useradd --no-log-init -m -u ${UID:-1000} ci

USER ci
RUN mkdir -p "${HOME}"/.local/bin
