FROM node:latest

WORKDIR /atmos-client

COPY package*.json ./

RUN npm i && npm cache clean --force;

COPY . .

ENV PORT=3000

EXPOSE $PORT

CMD ["npm", "run", "dev"]