FROM node:12-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app/component
ENTRYPOINT [ "node", "/usr/src/app/component/dist/index.js" ]