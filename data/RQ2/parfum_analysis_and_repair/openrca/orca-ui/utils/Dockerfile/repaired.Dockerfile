FROM node:12

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn --non-interactive && yarn cache clean;

COPY . ./

EXPOSE 3000

CMD ["yarn", "start"]
