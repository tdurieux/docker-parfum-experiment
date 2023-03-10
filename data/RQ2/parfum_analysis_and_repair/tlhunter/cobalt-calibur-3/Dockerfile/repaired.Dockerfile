FROM node:12

WORKDIR /srv

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8000
CMD ["node", "server.js", "8000", "0.0.0.0"]
