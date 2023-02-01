FROM node:11-alpine

WORKDIR  /src/app

RUN npm install -g serve && npm cache clean --force;

ADD yarn.lock package.json ./
RUN yarn install && yarn cache clean;

COPY . .

RUN yarn build

EXPOSE 5000
CMD ["serve", "-s", "build"]
