FROM python:3.7-slim-stretch

ENV DEBIAN_FRONTEND noninteractive
ENV PATH "/root/.poetry/bin:$PATH"

ADD . /tmp/apps/IndexTools

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    curl git make gcc \
    libc-dev zlib1g-dev libbz2-dev liblzma-dev libncurses-dev \
  && curl -f -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python \
  && cd /tmp/apps/IndexTools \
  && make && rm -rf /var/lib/apt/lists/*;

SHELL ["/bin/bash", "-c"]
