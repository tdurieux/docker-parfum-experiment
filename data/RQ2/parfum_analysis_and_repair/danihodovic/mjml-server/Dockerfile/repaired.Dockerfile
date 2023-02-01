FROM node:16-alpine

WORKDIR /app

COPY ./package.json ./package-lock.json /app/

RUN npm install && npm cache clean --force;

EXPOSE 15500

COPY . /app/

ENTRYPOINT ["node", "./index.js"]
