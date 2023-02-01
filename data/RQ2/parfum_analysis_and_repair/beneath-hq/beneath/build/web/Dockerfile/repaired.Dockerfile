FROM node:12-alpine

COPY ./package.json ./yarn.lock /source/
WORKDIR /source/
RUN yarn install && yarn cache clean;

COPY . /source
RUN yarn build

EXPOSE 3000
CMD ["yarn", "start"]
