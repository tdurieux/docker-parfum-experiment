FROM node:latest

WORKDIR /atmos-server

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENV PORT=3001

EXPOSE $PORT

CMD ["npm", "run", "dev"]