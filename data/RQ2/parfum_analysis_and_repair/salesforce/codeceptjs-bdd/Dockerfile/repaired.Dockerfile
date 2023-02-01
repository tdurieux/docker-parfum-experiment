FROM node:12

RUN \
    apt-get update \
    && apt-get install --no-install-recommends -y curl default-jdk && rm -rf /var/lib/apt/lists/*;

RUN mkdir /acceptance

RUN node --version

RUN npm --version

RUN yarn --version && yarn cache clean;

WORKDIR /acceptance

ENTRYPOINT [ "yarn" ]