FROM node:latest

ENV APP_PATH=/express-app
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

RUN npm init -y
RUN npm install -y express cors mysql2 pug jsonwebtoken cookie-parser csurf bcrypt express-validator dotenv && npm cache clean --force;