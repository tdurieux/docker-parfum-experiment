FROM node:lts
RUN \
  apt-get update \
  && apt-get -y --no-install-recommends install gettext-base \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
