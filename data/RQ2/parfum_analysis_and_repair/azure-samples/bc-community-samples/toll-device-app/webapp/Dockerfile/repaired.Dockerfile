FROM node:lts-alpine

WORKDIR /home/app
COPY build ./build
RUN npm install -g serve && npm cache clean --force;
CMD [ "serve", "-s", "build" ]