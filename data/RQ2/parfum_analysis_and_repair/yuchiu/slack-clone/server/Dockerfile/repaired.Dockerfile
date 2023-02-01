FROM node:10.10
WORKDIR /app
COPY package-lock.json .
COPY package.json .
COPY build build
COPY .env .
RUN npm install && npm cache clean --force;
CMD node build/server.js