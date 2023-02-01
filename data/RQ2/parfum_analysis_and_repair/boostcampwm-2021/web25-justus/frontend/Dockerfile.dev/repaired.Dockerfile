FROM node:16.0.0-alpine
WORKDIR /usr/src/app
COPY ./package.json ./
RUN yarn && yarn cache clean;
COPY . .
CMD ["yarn", "start"]