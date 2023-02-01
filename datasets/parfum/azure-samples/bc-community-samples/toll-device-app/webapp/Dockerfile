FROM node:lts-alpine

WORKDIR /home/app
COPY build ./build
RUN npm install -g serve
CMD [ "serve", "-s", "build" ]