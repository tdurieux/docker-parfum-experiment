FROM amazeeio/node:8-builder as builder
COPY package.json yarn.lock /app/
RUN yarn install --pure-lockfile && yarn cache clean;

FROM amazeeio/node:8
COPY --from=builder /app/node_modules /app/node_modules
COPY . /app/

ENV NODE_ENV production
RUN yarn build && yarn cache clean;

EXPOSE 3000
CMD ["yarn", "start"]
