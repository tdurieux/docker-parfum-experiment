FROM node:10.16-alpine

WORKDIR /app

COPY . .

RUN yarn && yarn cache clean;

EXPOSE 3000

CMD ["yarn", "start"]
