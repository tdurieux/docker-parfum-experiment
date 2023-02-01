FROM node:9.4.0

WORKDIR /usr/app

COPY package*.json ./

RUN npm install -qy && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
