# Base builder
#
#
FROM node:12 AS builder
WORKDIR /usr/src/spectrum
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .

# Athena builder
#
#
FROM builder AS builder-athena
WORKDIR /usr/src/spectrum
RUN yarn --cwd ./athena && yarn cache clean;
RUN yarn run build:athena && yarn cache clean;
RUN cp -r ./athena/node_modules ./build-athena

# Athena image
#
#
FROM node:12 AS athena
COPY --from=builder-athena /usr/src/spectrum/build-athena /usr/src/athena
WORKDIR /usr/src/athena
CMD ["yarn", "run", "start"]
