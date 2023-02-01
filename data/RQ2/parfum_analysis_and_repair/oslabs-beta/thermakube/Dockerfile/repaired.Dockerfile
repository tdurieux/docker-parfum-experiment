FROM node:12.14
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;
RUN npm run build
EXPOSE 3000
CMD node ./server/server.js