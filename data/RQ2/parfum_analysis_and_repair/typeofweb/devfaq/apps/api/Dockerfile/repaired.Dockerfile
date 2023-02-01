FROM node:12-alpine
WORKDIR /app

#copy all the app files
COPY . .

RUN yarn install && yarn cache clean;
RUN yarn run build && yarn cache clean;

CMD NODE_ENV=production yarn start
