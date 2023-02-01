FROM node:9
LABEL maintainer "Ives van Hoorne"

COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock

WORKDIR /app
RUN yarn config set workspaces-experimental true && yarn cache clean;
RUN yarn install && yarn cache clean;

# After yarn install, so dev deps are also installed (for building)
ENV NODE_ENV production

ADD . /app
RUN npm run build
