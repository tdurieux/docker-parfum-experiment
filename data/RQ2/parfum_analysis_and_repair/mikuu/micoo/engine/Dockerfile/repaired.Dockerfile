FROM node:15

WORKDIR /usr/src/app
RUN mkdir -p screenshots

COPY . .
RUN yarn install && yarn cache clean;

EXPOSE 3002

CMD ["yarn", "start"]
