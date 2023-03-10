FROM node:18-alpine

WORKDIR /usr/app/src

ADD package.json package.json
RUN yarn install --frozen-lockfile --production --silent && yarn cache clean;

EXPOSE 3000

CMD ["node", "duo_api.js"]
