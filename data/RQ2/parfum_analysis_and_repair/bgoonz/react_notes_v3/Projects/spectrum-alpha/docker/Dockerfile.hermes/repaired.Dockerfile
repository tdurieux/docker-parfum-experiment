# Base builder
#
#
FROM node:12 AS builder
WORKDIR /usr/src/spectrum
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .

# hermes builder
#
#
FROM builder AS builder-hermes
WORKDIR /usr/src/spectrum
RUN yarn --cwd ./hermes && yarn cache clean;
RUN yarn run build:hermes && yarn cache clean;
RUN cp -r ./hermes/node_modules ./build-hermes

# hermes image
#
#
FROM node:12 AS hermes
COPY --from=builder-hermes /usr/src/spectrum/build-hermes /usr/src/hermes
WORKDIR /usr/src/hermes
CMD ["yarn", "run", "start"]
