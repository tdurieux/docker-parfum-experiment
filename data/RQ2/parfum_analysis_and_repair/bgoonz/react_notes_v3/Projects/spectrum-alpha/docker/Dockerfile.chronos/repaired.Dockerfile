# Base builder
#
#
FROM node:12 AS builder
WORKDIR /usr/src/spectrum
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .

# chronos builder
#
#
FROM builder AS builder-chronos
WORKDIR /usr/src/spectrum
RUN yarn --cwd ./chronos && yarn cache clean;
RUN yarn run build:chronos && yarn cache clean;
RUN cp -r ./chronos/node_modules ./build-chronos

# chronos image
#
#
FROM node:12 AS chronos
COPY --from=builder-chronos /usr/src/spectrum/build-chronos /usr/src/chronos
WORKDIR /usr/src/chronos
CMD ["yarn", "run", "start"]
