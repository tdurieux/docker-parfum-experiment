FROM node:carbon

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY ./ /usr/src/app
# COPY env.example /usr/src/app/.env

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
