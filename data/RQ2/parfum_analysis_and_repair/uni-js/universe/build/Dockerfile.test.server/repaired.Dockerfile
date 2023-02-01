FROM node:14

WORKDIR /app
ENV DB_LOCATION=./data/

COPY . .

RUN yarn --registry=https://registry.npmmirror.com/ && yarn cache clean;
RUN yarn build:server && yarn cache clean;

EXPOSE 6100
CMD [ "node", "./lib/server/bootstrap" ]