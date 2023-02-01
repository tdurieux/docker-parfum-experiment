FROM node:16.13.2-buster-slim

WORKDIR /usr/src/app

COPY package.json yarn.lock /usr/src/app/

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    gnupg2 && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update \
    && apt-get install -y jq git python3 build-essential yarn --no-install-recommends \
    && yarn cache clean \
    && yarn install --frozen-lockfile --production --ignore-optional --network-concurrency=1 \
    && apt-get autoremove --purge -y python3 git build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && yarn cache clean \
    && rm -rf ~/.node-gyp \
    && rm -rf /tmp/yarn-* && yarn cache clean;

# Keep the .git directory in order to properly report version
COPY . /usr/src/app

ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]
CMD [ "yarn", "start" ]

EXPOSE 8100
