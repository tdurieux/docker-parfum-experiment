FROM node:8.17

RUN mkdir /app
WORKDIR /app

COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "start"]
