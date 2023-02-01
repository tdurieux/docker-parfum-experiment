FROM node:14-stretch-slim

RUN yarn global add pm2 && yarn cache clean;

RUN mkdir -p /api
WORKDIR /api

COPY . /api

RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn build && yarn cache clean;

EXPOSE 80

CMD ["pm2", "start", "dist/index.js", "--no-daemon"]