FROM node:17.6

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

RUN groupadd appgroup && useradd -g appgroup appuser

COPY . /app/

EXPOSE 3000

USER appuser

CMD node server.js