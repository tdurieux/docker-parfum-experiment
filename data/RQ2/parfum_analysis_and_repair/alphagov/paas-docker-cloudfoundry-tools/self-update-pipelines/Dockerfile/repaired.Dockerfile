FROM ruby:2.7-slim-buster

ENV AWSCLI_VERSION "1.17.2"
ENV PACKAGES make python-setuptools python-pip groff less curl

RUN apt-get update \
      && apt-get install -y --no-install-recommends $PACKAGES \
      && rm -rf /var/lib/apt/lists/* \
      && pip install --no-cache-dir awscli==$AWSCLI_VERSION
