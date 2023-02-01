FROM node:13

WORKDIR /app

COPY ./package.json .
COPY ./yarn.lock .

RUN yarn install && yarn cache clean;

COPY . .

RUN yarn build

EXPOSE 4000
ENV PORT 4000
ENV NODE_ENV production

CMD ["yarn", "start:prod"]
