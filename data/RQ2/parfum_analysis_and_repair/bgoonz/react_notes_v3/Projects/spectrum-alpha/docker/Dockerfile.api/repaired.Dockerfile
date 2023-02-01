# Base builder
#
#
FROM node:12 AS builder
WORKDIR /usr/src/spectrum
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .

# API builder
#
#
FROM builder AS builder-api
WORKDIR /usr/src/spectrum
RUN yarn --cwd ./api && yarn cache clean;
RUN yarn run build:api && yarn cache clean;
RUN cp -r ./api/node_modules ./build-api

# API image
#
#
FROM node:12 AS api
COPY --from=builder-api /usr/src/spectrum/build-api /usr/src/api
WORKDIR /usr/src/api
CMD ["yarn", "run", "start"]
