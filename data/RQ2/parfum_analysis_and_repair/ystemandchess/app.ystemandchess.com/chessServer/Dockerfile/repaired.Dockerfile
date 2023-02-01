FROM node

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;
RUN npm ci --only=production

COPY . .

EXPOSE 3000
CMD [ "node", "index.js" ]