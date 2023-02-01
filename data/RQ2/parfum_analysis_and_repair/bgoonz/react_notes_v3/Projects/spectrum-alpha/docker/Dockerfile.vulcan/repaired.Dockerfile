# Base builder
#
#
FROM node:12 AS builder
WORKDIR /usr/src/spectrum
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .

# vulcan builder
#
#
FROM builder AS builder-vulcan
WORKDIR /usr/src/spectrum
RUN yarn --cwd ./vulcan && yarn cache clean;
RUN yarn run build:vulcan && yarn cache clean;
RUN cp -r ./vulcan/node_modules ./build-vulcan

# vulcan image
#
#
FROM node:12 AS vulcan
COPY --from=builder-vulcan /usr/src/spectrum/build-vulcan /usr/src/vulcan
WORKDIR /usr/src/vulcan
CMD ["yarn", "run", "start"]
