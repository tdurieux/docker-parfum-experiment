FROM node:12.16.1-alpine3.11
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;

COPY . .

EXPOSE 3000
EXPOSE 3001

ENTRYPOINT [ "node", "." ]
