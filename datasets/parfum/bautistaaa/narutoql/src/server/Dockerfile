FROM node:12

RUN mkdir /server

WORKDIR /server

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8000

ARG MONGOPORT
ARG MONGOUSER
ARG MONGO_URL
ARG PORT
ARG RAILWAY_ENVIRONMENT
ARG RAILWAY_STATIC_URL
ARG MONGOHOST
ARG MONGOPASSWORD

RUN npm run build

CMD ["npm", "start"]
