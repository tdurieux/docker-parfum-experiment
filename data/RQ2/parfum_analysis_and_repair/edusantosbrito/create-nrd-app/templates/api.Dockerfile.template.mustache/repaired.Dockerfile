FROM node:14-slim
WORKDIR /usr/src/app
COPY . .
RUN yarn add -D typescript && yarn cache clean;
RUN yarn build && yarn cache clean;
RUN yarn --network-timeout 1000000 && yarn cache clean;
EXPOSE 3000
CMD [ "yarn", "start" ]