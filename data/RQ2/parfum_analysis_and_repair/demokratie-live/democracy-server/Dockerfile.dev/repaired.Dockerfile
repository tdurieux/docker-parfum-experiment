FROM node:12-alpine

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile && yarn cache clean;

COPY . .

ENV NODE_ENV=development

ENTRYPOINT [ "yarn", "dev" ]