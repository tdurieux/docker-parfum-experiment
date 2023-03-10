# Base builder
#
#
FROM node:12 AS builder
WORKDIR /usr/src/spectrum
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .

# mercury builder
#
#
FROM builder AS builder-mercury
WORKDIR /usr/src/spectrum
RUN yarn --cwd ./mercury && yarn cache clean;
RUN yarn run build:mercury && yarn cache clean;
RUN cp -r ./mercury/node_modules ./build-mercury

# mercury image
#
#
FROM node:12 AS mercury
COPY --from=builder-mercury /usr/src/spectrum/build-mercury /usr/src/mercury
WORKDIR /usr/src/mercury
CMD ["yarn", "run", "start"]
