FROM node:carbon
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 46657
CMD [ "node", "node1.js" ]
