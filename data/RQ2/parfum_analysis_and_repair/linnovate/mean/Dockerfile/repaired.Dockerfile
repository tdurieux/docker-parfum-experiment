FROM node:14.18-alpine

WORKDIR /usr/src/app
COPY . /usr/src/app

ENV HUSKY_SKIP_INSTALL=true
RUN yarn --pure-lockfile --non-interactive --no-progress && yarn cache clean;
RUN yarn build:prod && yarn cache clean;

EXPOSE 4040

CMD ["yarn", "serve"]
