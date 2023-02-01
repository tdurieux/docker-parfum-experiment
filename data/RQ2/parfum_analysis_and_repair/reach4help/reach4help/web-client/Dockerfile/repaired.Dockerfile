FROM node:latest

WORKDIR /app

COPY ./package.json ./

RUN yarn && yarn cache clean;

COPY ./ ./

CMD ["yarn", "start"]

EXPOSE 3000
