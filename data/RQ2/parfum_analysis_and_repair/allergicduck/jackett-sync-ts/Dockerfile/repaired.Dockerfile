FROM node:16-alpine

COPY . /jackett-sync

WORKDIR /jackett-sync

RUN npm install && npm cache clean --force;
RUN npm run build

ENTRYPOINT [ "node", "dist/src/main.js" ]