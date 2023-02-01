FROM node:latest

RUN npm install -g nodemon forever && npm cache clean --force;

RUN apt-get update && apt-get -y --no-install-recommends install cron && rm -rf /var/lib/apt/lists/*;

COPY . app

WORKDIR /app

RUN npm install && npm cache clean --force;

RUN npm install --prefix client && npm cache clean --force;

RUN npm run build

EXPOSE 3000

CMD [ "node", "server.js" ]
