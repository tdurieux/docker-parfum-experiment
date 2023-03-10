FROM node:6-slim
MAINTAINER Giorgio Regni <gr@scality.com>

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN apt-get update \
    && apt-get install -y jq python git build-essential --no-install-recommends \
    && yarn install --production \
    && apt-get autoremove --purge -y python git build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && yarn cache clean \
    && rm -rf ~/.node-gyp \
    && rm -rf /tmp/yarn-* && yarn cache clean;

ENV S3BACKEND mem

ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]
CMD [ "yarn", "start" ]

EXPOSE 8000
