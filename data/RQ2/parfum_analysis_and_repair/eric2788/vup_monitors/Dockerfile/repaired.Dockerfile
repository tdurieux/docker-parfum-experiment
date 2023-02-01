FROM node:16-alpine

WORKDIR /app

COPY ./src ./src
COPY *.json .

RUN npm install && npm cache clean --force;

VOLUME [ "/app/data"，"/app/caches" ]

CMD [ "npm", "run", "start" ]