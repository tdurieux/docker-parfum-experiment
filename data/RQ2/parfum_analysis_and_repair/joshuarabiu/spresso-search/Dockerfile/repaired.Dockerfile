FROM node:10.1.0
COPY . .
RUN yarn install --production && yarn build && yarn cache clean;
WORKDIR ./server
EXPOSE 1337
CMD node ./build/server.js