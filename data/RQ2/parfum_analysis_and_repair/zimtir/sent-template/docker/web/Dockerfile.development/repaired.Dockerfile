FROM node:lts-alpine

RUN export NODE_PATH=/usr/local/lib/node_modules

WORKDIR /var/www/web

# required folders
COPY bundlers ./bundlers
COPY public ./public
COPY src ./src

# required files
COPY fontello.config.json .
COPY design/swagger.json ./design/swagger.json
COPY package.json .
COPY package-lock.json .
COPY rollup.config.js .
COPY tsconfig.json .

# ability to avoid issues with build of scss
# https://github.com/thgh/rollup-plugin-scss/issues/61
RUN npm install -g --unsafe-perm node-sass && npm cache clean --force;

# install only required deps at Docker container to start development server
RUN npm ci --no-optional

EXPOSE 3000
