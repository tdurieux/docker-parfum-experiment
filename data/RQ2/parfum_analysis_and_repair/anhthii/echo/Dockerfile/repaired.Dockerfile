FROM node:14

WORKDIR /usr/src/echo

ADD package*.json ./

RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

CMD ["npm", "run", "server"]

EXPOSE 3000
