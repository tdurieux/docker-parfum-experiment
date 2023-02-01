FROM ubuntu:14.04
MAINTAINER Filipe Garcia <filipe.garcia@seedstarslabs.com>

COPY ./docker/web/web-entrypoint.sh /

WORKDIR /django

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install --no-install-recommends -y nodejs yarn && rm -rf /var/lib/apt/lists/*;

COPY ./package.json /django/package.json
