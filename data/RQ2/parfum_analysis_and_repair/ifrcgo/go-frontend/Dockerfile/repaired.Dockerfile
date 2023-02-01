FROM node:14.18.2-buster

LABEL maintainer="Togglecorp dev@togglecorp.com"

RUN apt-get -y update \
  && apt-get -y install --no-install-recommends git bash && rm -rf /var/lib/apt/lists/*;

WORKDIR /code
COPY . /code/
