FROM node:10.11
MAINTAINER jonathan.soeder@gmail.com
EXPOSE 3000
WORKDIR /app
RUN mkdir -p /app/node_modules /app
COPY package.json /app/package.json
RUN yarn --ignore-scripts && yarn cache clean;
COPY . /app
RUN yarn build && yarn cache clean;
CMD yarn start
