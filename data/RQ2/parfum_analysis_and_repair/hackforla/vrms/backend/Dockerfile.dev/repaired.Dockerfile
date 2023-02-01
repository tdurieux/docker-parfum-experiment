FROM node:14.11.0 AS api-development
RUN mkdir /srv/backend
WORKDIR /srv/backend
RUN mkdir -p node_modules
COPY package.json yarn.lock ./
RUN yarn install --pure-lockfile && yarn cache clean;
COPY . .
