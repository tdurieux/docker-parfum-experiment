FROM mhart/alpine-node:8

WORKDIR /app

RUN npm install -g yarn && npm cache clean --force;

COPY . .

RUN yarn
RUN yarn test && yarn cache clean;
