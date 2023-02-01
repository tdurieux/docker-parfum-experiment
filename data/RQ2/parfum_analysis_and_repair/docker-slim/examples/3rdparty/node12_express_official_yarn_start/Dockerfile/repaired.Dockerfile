FROM node:12

WORKDIR /usr/src/app
COPY service/package*.json ./
RUN yarn install && yarn cache clean;
COPY service/ .

EXPOSE 1300
CMD [ "yarn", "start" ]
