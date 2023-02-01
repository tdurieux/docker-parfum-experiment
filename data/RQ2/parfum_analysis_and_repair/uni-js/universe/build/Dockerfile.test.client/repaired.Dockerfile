FROM node:14

ARG server_url
ENV UNIVERSE_SERVER_URL ${server_url}

WORKDIR /app

COPY . .

RUN yarn --registry=https://registry.npmmirror.com/ && yarn cache clean;
RUN yarn build:client && yarn cache clean;
RUN yarn global add serve && yarn cache clean;

EXPOSE 5000
CMD [ "serve", "-s", "web-dist", "-p", "5000" ]