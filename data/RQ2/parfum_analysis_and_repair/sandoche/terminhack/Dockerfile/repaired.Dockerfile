FROM node:14

WORKDIR /usr/src/app

COPY . .

RUN npm install && npm cache clean --force;
RUN npm run build

EXPOSE 3000
CMD [ "node", "./bin/www" ]