FROM node:16 as build
WORKDIR /build/app
COPY bot/package.json bot/yarn.lock bot/.yarnrc.yml ./
COPY bot/.yarn ./.yarn
COPY lib ../lib
RUN yarn install --immutable && yarn cache clean;
COPY ./bot .
RUN yarn build && yarn cache clean;

FROM node:16 as prod
WORKDIR /app/bot
COPY --from=build /build/app/package.json /build/app/yarn.lock /build/app/.yarnrc.yml ./
COPY --from=build /build/app/.yarn ./.yarn
COPY --from=build /build/app/dist ./dist
COPY ./lib ../lib
RUN yarn install --immutable && yarn cache clean;
CMD ["yarn", "start"]
