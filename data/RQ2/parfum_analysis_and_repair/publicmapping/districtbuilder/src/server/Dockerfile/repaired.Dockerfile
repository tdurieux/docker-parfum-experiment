FROM node:16-bullseye-slim

RUN mkdir -p /home/node/app/server
WORKDIR /home/node/app/server

RUN set -ex \
    && deps=" \
    procps=2:3.3* \
    " \
    && apt-get update && apt-get install -yq $deps --no-install-recommends && rm -rf /var/lib/apt/lists/*;

COPY package.json /home/node/app/server
COPY yarn.lock /home/node/app/server
RUN set -ex \
    && yarn install && yarn cache clean;

COPY . /home/node/app/server

ENTRYPOINT ["yarn"]
CMD ["start:prod"]
