FROM ubuntu:18.04 as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    software-properties-common \
    apt-transport-https \
    curl \

    build-essential && rm -rf /var/lib/apt/lists/*;

# libindy
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
RUN add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable"

# nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash

# yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# install depdencies
RUN apt-get update -y && apt-get install --no-install-recommends -y --allow-unauthenticated \
    libindy \
    nodejs && rm -rf /var/lib/apt/lists/*;

# Install yarn seperately due to `no-install-recommends` to skip nodejs install
RUN apt-get install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

# AFJ specifc setup
WORKDIR /www

COPY bin ./bin
COPY package.json package.json
RUN yarn install --production && yarn cache clean;

COPY build ./build

ENTRYPOINT [ "./bin/afj-rest.js", "start" ]
