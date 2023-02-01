FROM node:10

COPY . /app

WORKDIR /app

RUN rm -rf node_modules && \
    yarn install && \
    yarn build && yarn cache clean;

EXPOSE 3000
