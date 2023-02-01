FROM node:12 AS builder
WORKDIR /usr/src/spectrum
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .

FROM builder AS builder-hyperion
RUN yarn --cwd ./hyperion && yarn cache clean;
RUN yarn run build:hyperion && yarn cache clean;
RUN yarn --cwd ./build-hyperion && yarn cache clean;

FROM node:12 AS hyperion
COPY --from=builder-hyperion /usr/src/spectrum/build-hyperion /usr/src/spectrum-hyperion
WORKDIR /usr/src/spectrum-hyperion
CMD ["yarn", "run", "start"]
