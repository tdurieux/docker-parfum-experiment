FROM node:11

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

CMD ["node", "main.js"]
