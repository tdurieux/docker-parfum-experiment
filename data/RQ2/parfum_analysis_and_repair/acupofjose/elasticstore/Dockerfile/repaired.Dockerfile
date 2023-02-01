FROM node:12

WORKDIR /app

COPY package.json ./
COPY *.lock ./

RUN npm install && npm cache clean --force;

COPY . .

CMD npm start