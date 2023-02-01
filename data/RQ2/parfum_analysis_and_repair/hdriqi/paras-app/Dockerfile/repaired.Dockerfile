FROM node:12.14.1

WORKDIR /usr/src/app

COPY ./package.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 4000
CMD [ "npm", "run", "dev" ]