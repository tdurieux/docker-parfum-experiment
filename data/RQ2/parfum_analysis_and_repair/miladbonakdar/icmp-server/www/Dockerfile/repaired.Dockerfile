FROM node:8-alpine

RUN npm install -g http-server && npm cache clean --force;

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

EXPOSE 8080

CMD [ "http-server", "dist" ,"--proxy" ,"http://icmp-server:3000"]