FROM node:14

WORKDIR /app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY src ./src
COPY *.js ./

RUN node download-models.js

EXPOSE 3000

CMD [ "node", "index.js" ]
