FROM node:14.11.0 as build-stage
WORKDIR /app
COPY package*.json /app/
RUN npm install && npm cache clean --force;
COPY . /app/
EXPOSE 8080
CMD npm run serve
