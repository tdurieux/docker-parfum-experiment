FROM node:16.13
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
RUN npm run build
EXPOSE 3000
ENTRYPOINT ["node", "--loader", "ts-node/esm", "server/server.ts"]