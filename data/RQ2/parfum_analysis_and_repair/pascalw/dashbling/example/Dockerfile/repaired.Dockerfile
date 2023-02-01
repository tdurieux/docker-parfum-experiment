FROM node:8.9-alpine
WORKDIR /app/

ADD package.json yarn.lock /app/
RUN yarn install && yarn cache clean;

ADD . /app
RUN yarn build && yarn cache clean;

FROM node:8.9-alpine
WORKDIR /app/

ADD package.json yarn.lock /app/
RUN yarn install --production && yarn cache clean;

ADD . /app/
COPY --from=0 /app/dist /app/dist

ENV NODE_ENV=production
CMD ["./node_modules/.bin/dashbling", "start"]