FROM node:16.13-alpine

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json /app/package.json
RUN yarn install --silent && yarn cache clean;

COPY . .

CMD ["yarn", "start"]
