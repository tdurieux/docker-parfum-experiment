FROM node:10-slim

ADD . /app
WORKDIR /app/api

# This will also trigger the build process
RUN yarn install && yarn cache clean;

ENV PORT=80
EXPOSE 80

CMD yarn start
