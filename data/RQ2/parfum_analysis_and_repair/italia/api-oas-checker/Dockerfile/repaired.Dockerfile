FROM node:14.15

ADD . /app
WORKDIR /app
RUN yarn install --frozen-lockfile && yarn cache clean;
ENTRYPOINT ["yarn", "start"]