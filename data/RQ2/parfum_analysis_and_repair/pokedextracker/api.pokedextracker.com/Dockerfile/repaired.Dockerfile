FROM node:6.14.2

RUN mkdir /app
WORKDIR /app

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn --production --silent && yarn cache clean;

COPY . .

CMD ["node", "src/index.js"]
