FROM node:14

WORKDIR ./

COPY ./package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000 4000

CMD ["npm", "start"]