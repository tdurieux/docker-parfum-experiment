# For Development
FROM node:14.1.0-alpine as node
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 4200
CMD npm run start