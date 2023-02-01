FROM node:8-alpine
WORKDIR /react-client
COPY package.json /react-client/
RUN yarn && yarn cache clean;
EXPOSE 3000
