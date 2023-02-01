FROM node:16
WORKDIR /usr/duxcore-website

COPY package.json .
RUN yarn install && yarn cache clean;

COPY . .
RUN yarn build

EXPOSE 8050

CMD yarn start
