# STAGE: Development
FROM node:14 AS dev
WORKDIR /app
EXPOSE 3000
COPY . .
RUN yarn && yarn cache clean;

# Stage CI
FROM node:14 as ci

RUN mkdir -p /ci/app/ && chown -R node:node /ci/app
WORKDIR /ci/app
COPY --chown=node:node . .

USER node
ENV MONGODB_URI "mongodb://mongo:27017/race"

RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;
CMD yarn start
