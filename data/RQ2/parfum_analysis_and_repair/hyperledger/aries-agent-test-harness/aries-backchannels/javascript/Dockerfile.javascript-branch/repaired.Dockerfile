FROM ubuntu:18.04 as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    software-properties-common \
    apt-transport-https \
    curl \
    git \

    build-essential && rm -rf /var/lib/apt/lists/*;

# libindy
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
RUN add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable"

# nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash

# yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# install depdencies
RUN apt-get update -y && apt-get install --no-install-recommends -y --allow-unauthenticated \
    libindy \
    nodejs && rm -rf /var/lib/apt/lists/*;

# Install yarn seperately due to `no-install-recommends` to skip nodejs install
RUN apt-get install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

FROM base as final

WORKDIR /dependencies

RUN git clone https://github.com/TimoGlastra/aries-framework-javascript && cd aries-framework-javascript && git checkout fix/credential-preview-type && yarn install && yarn build && yarn cache clean;

WORKDIR /src
ENV RUN_MODE="docker"

COPY javascript/server/package.json package.json

RUN yarn add file:/dependencies/aries-framework-javascript/packages/core && yarn cache clean;
RUN yarn add file:/dependencies/aries-framework-javascript/packages/node && yarn cache clean;

# Run install after copying only depdendency file
# to make use of docker layer caching
RUN yarn install && yarn cache clean;

# Copy other depedencies
COPY javascript/server .
COPY javascript/ngrok-wait.sh ./ngrok-wait.sh

# For now we use ts-node. Compiling with typescript
# doesn't work because indy-sdk types are not exported
ENTRYPOINT [ "bash", "ngrok-wait.sh"]