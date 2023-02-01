FROM node:12.15.0-alpine AS decks-service-builder
WORKDIR /home/service/decks-service
COPY . ./
RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn run build

FROM node:12.15.0-alpine
ENV NODE_ENV=production
WORKDIR /home/service/decks-service
COPY --from=decks-service-builder /home/service/decks-service/build ./build
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --no-cache --production && yarn cache clean;
CMD yarn start