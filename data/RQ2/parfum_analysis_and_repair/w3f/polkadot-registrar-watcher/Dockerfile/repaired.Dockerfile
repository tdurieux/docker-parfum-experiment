FROM node:14.18.1-alpine3.11

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn --ignore-scripts && yarn cache clean;

COPY . .
RUN yarn && \
  yarn build && yarn cache clean;

ENTRYPOINT ["yarn", "start"]
