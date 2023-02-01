FROM node:10.15

WORKDIR /usr/src

COPY package*.json ./

RUN npm install && npm cache clean --force;

EXPOSE 3200

CMD ["npm", "run", "dev"]
