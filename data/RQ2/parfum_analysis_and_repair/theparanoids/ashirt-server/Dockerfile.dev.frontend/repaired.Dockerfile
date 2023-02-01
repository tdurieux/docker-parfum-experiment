FROM node:16.14-alpine

RUN mkdir /app
WORKDIR /app

COPY frontend/package.json frontend/package-lock.json ./
RUN npm install && npm cache clean --force;

COPY frontend/ ./

CMD ["npm", "start"]
