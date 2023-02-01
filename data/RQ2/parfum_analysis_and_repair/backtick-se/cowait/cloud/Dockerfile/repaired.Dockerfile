FROM node:latest
RUN mkdir /app
WORKDIR /app
EXPOSE 1339

COPY ./package.json .
RUN npm install && npm cache clean --force;

COPY ./public /app/public
COPY ./src /app/src

CMD ["npm", "start"]