FROM node:12.3.1

WORKDIR /app

COPY package*.json /app/

RUN npm install --only=prod && npm cache clean --force;

COPY src /app/src

CMD cd /app && npm run start