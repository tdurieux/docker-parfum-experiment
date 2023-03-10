FROM node:latest

RUN mkdir /app
RUN mkdir /app/assets
RUN mkdir /app/assets/javascripts

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./package-lock.json /app/package-lock.json
COPY ./webpack.config.js /app/webpack.config.js
COPY ./frontend /app/frontend

RUN npm install && npm cache clean --force;

CMD ["npm", "run", "start"]