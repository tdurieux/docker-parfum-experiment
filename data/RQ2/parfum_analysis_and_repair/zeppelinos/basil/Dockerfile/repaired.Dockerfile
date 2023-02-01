FROM node:10.0
WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;
ADD . /app