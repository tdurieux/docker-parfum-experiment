FROM node:16-buster

WORKDIR /app

COPY *.json ./
COPY yarn.lock ./

RUN yarn && yarn cache clean;

COPY . .

# RUN yarn res:build
RUN yarn build && yarn cache clean;

CMD ["yarn", "start"]