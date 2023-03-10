FROM node:14.18-alpine

# YARN_PRODUCTION=false is a workaround for https://github.com/yarnpkg/yarn/issues/4557
ENV NODE_ENV=production \
  YARN_PRODUCTION=false

# taken from node:6-onbuild
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# COPY in dev versions
COPY . /usr/src/app

RUN apk --no-cache --virtual .build add build-base python2 git \
  && yarn install --pure-lockfile --production=false \
  && apk del .build && yarn cache clean;
COPY . /usr/src/app

# for git 2.1.4
RUN apk --no-cache --virtual .git add git \
  && yarn create-version-file \
  && rm -rf .git \
  && apk del .git && yarn cache clean;

CMD [ "yarn", "start" ]
