FROM timbru31/node-alpine-git

WORKDIR /usr/src/app
COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app
RUN yarn install --no-progress --pure-lockfile --prod && yarn cache clean;
