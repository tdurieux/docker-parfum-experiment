FROM node:7.9.0-alpine
WORKDIR /app
COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080

USER nobody
CMD npm start
