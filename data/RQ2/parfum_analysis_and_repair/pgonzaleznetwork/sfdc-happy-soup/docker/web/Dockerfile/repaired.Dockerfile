FROM node:alpine

EXPOSE 3000

WORKDIR /app

COPY ./package.json ./package-lock.json* /app/

RUN npm install && npm cache clean --force;

COPY ./ /app

CMD ["node","backend/server/www"]