FROM node:8.16
ENV NODE_ENV production

WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .


EXPOSE 3000
CMD [ "node", "src/index.js" ]