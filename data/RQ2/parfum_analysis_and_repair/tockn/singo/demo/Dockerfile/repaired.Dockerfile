FROM node:lts-alpine

RUN npm install -g http-server && npm cache clean --force;

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

RUN rm -rf /app/node_modules

EXPOSE 8080
CMD [ "http-server", "dist" ]
