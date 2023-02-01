FROM node:12.2.0-alpine

WORKDIR /app

COPY build/ ./

RUN npm install -g serve && npm cache clean --force;

EXPOSE 8080

CMD ["serve", "-s", "." , "-l", "8080"]