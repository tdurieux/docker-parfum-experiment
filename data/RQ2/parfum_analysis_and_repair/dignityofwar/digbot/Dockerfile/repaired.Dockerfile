FROM node:16-alpine AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean;

COPY . .
RUN yarn run build && yarn cache clean;
RUN npx mikro-orm cache:generate

FROM node:16-alpine

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean;

COPY mikro-orm.config.js .
COPY migrations ./migrations
COPY --from=build /usr/src/app/temp ./temp
COPY --from=build /usr/src/app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]
