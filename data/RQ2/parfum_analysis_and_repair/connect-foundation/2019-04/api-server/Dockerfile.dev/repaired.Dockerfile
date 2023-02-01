FROM node:12.13.0

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3030
CMD [ "npm", "run", "dev" ]
