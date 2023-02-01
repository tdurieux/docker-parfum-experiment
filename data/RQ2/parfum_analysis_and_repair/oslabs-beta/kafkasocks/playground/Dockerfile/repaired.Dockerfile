FROM node:16.1.0
RUN npm i -g webpack && npm cache clean --force;
RUN npm i -g ts-node && npm cache clean --force;
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
RUN npm run build
EXPOSE 3001
CMD ["ts-node", "./server/server.ts"]
