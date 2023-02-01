FROM node:12.16.1-stretch
WORKDIR /usr/src/app
ADD package.json ./
RUN yarn install --production=true && yarn cache clean;
COPY dist .
CMD [ "node", "./cli.js" ]