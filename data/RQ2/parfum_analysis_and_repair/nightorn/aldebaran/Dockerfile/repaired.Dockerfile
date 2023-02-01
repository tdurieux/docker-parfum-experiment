FROM node:16-alpine

RUN apk update
RUN apk add --no-cache gcc git g++ make musl-dev pkgconfig python3

WORKDIR /app

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

CMD npm start
