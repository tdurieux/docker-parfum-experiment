FROM node:16 as build-stage

WORKDIR /app
COPY package*.json /app/
RUN npm install && npm cache clean --force;
COPY ./ /app/
EXPOSE 3001

ENTRYPOINT npm run start
