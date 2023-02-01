FROM node:alpine

WORKDIR "/app"

COPY ./package.json ./
RUN yarn install && yarn cache clean;
COPY . .

CMD ["yarn","run","dev"]