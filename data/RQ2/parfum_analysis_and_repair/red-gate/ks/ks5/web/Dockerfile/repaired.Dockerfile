FROM node:8.6.0

ADD ./app /app

WORKDIR /app

EXPOSE 3000

RUN yarn install && yarn cache clean;
RUN yarn && yarn cache clean;
CMD ["yarn", "start"]