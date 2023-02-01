FROM node:16-alpine

WORKDIR /server

COPY . /server
RUN yarn install && yarn cache clean;

EXPOSE 3000
CMD [ "yarn", "start" ]
