FROM node:12-alpine

WORKDIR /app

COPY . .

RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;

EXPOSE 3000

ENTRYPOINT ["yarn", "serve"]
