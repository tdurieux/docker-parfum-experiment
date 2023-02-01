FROM node:12

RUN mkdir /client

WORKDIR /client

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
