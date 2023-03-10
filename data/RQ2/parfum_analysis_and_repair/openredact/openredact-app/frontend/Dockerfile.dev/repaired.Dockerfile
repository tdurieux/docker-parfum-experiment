# build and run the frontend
FROM node:10

WORKDIR /app

COPY package*.json /app/

RUN npm install && npm cache clean --force;

ENV REACT_APP_API_BASE_URL=http://127.0.0.1:8000/api

COPY public /app/public
COPY src /app/src
