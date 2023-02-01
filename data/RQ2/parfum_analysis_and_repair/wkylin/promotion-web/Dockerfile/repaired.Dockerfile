FROM node:alpine
WORKDIR /promotion-web
COPY package.json /promotion-web
RUN yarn install && yarn cache clean;
COPY . /promotion-web
CMD ["yarn", "run", "start"]