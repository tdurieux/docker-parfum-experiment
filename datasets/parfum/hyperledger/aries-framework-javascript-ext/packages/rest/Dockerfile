FROM ubuntu:18.04 as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    apt-transport-https \
    curl \
    # Only needed to build indy-sdk
    build-essential 

# libindy
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
RUN add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable"

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# install depdencies
RUN apt-get update -y && apt-get install -y --allow-unauthenticated \
    libindy \
    nodejs

# Install yarn seperately due to `no-install-recommends` to skip nodejs install 
RUN apt-get install -y --no-install-recommends yarn

# AFJ specifc setup
WORKDIR /www

COPY bin ./bin
COPY package.json package.json
RUN yarn install --production

COPY build ./build

ENTRYPOINT [ "./bin/afj-rest.js", "start" ]
