FROM node:16-alpine
WORKDIR /app

COPY package.json .
RUN npm i && npm cache clean --force;
COPY index.js .

EXPOSE 3000

CMD [ "npm", "start" ]