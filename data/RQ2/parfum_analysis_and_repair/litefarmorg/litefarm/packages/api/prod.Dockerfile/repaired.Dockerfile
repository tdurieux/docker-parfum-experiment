FROM node:16.13.2

WORKDIR /usr/src/app

COPY ./package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm install -g nodemon && npm cache clean --force;

CMD npm run migrate:dev:db && nodemon --exec 'npm run start:prod || echo // `date` >> crashlog.js'
