FROM node:8

WORKDIR /app

COPY package.json /app/
COPY package-lock.json /app/
RUN npm install && npm cache clean --force;
COPY . /app

ENTRYPOINT [ "node", "lib/start" ])
