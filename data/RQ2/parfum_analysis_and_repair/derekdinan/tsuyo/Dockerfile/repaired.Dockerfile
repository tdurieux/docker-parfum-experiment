FROM node:12.19.0

WORKDIR /usr/src/app

COPY package*.json /usr/src/app/
RUN npm install && npm cache clean --force;

COPY . .

CMD [ "npm", "run", "nodemon" ]
