FROM node:12-alpine

WORKDIR /app

COPY Frontend/package.json ./Frontend/package.json
COPY Frontend/package-lock.json ./Frontend/package-lock.json
COPY SharedUtils/package.json ./SharedUtils/package.json
COPY SharedUtils/package-lock.json ./SharedUtils/package-lock.json

RUN apk add --no-cache git

RUN cd Frontend && npm install && npm cache clean --force;
RUN cd SharedUtils && npm install && npm cache clean --force;

COPY Frontend Frontend
COPY SharedUtils SharedUtils

WORKDIR /app/Frontend

EXPOSE 8100

CMD ["npm", "run", "start"]
