FROM node:12
WORKDIR /usr/src/app
COPY package.json ./
RUN npm install && npm cache clean --force;
COPY app.js .
EXPOSE 7000
CMD [ "node", "app.js" ]