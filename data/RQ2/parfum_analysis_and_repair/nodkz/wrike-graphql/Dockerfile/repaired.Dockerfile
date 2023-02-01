FROM node:10-alpine

WORKDIR /app

COPY package.json yarn.lock dist/ .env ./

RUN yarn install --production && yarn cache clean;
ENV PORT=3000

EXPOSE 3000
CMD [ "node", "server.js" ]