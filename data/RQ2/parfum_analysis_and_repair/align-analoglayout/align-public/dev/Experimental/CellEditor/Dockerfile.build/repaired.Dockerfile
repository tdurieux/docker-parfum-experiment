FROM node:9.11.1-alpine

RUN npm install -g http-server && npm cache clean --force;

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

EXPOSE 8080

CMD ["http-server", "dist"]
