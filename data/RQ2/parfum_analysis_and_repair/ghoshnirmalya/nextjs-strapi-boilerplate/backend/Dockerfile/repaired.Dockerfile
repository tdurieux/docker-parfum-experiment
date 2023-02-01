FROM strapi/base

COPY ./app/package.json ./
COPY ./app/yarn.lock ./

RUN yarn install && yarn cache clean;

COPY ./app .

ENV NODE_ENV production

RUN yarn build && yarn cache clean;

EXPOSE 1337

CMD ["yarn", "start"]
