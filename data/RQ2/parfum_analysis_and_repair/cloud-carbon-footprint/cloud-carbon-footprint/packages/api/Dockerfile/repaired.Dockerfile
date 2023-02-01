FROM node:14-alpine
WORKDIR /usr/src/app
COPY ./dist ./dist
COPY ./package.json .
RUN yarn install --immutable && yarn cache clean;
RUN rm -rf core

CMD [ "yarn", "start:webprod"]
