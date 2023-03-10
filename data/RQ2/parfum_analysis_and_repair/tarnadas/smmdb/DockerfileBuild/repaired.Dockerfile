FROM timbru31/node-alpine-git

# Create directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install dependencies
COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app
RUN yarn install --no-progress --pure-lockfile --prod && yarn cache clean;
RUN yarn install --no-progress --pure-lockfile --prefer-offline && yarn cache clean;

# COPY Files
COPY ./static /usr/src/app/static
COPY ./config /usr/src/app/config
COPY ./src /usr/src/app/src
COPY .babelrc /usr/src/app/.babelrc
COPY .eslintrc /usr/src/app/.eslintrc
COPY favicon.ico /usr/src/app/favicon.ico
COPY package.json /usr/src/app/package.json
RUN true
COPY tsconfig.json /usr/src/app/tsconfig.json
COPY webpack.config.js /usr/src/app/webpack.config.js

# Build
RUN yarn build
