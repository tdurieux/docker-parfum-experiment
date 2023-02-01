FROM node:16

WORKDIR /app

COPY ./package*.json .

RUN npm install && npm cache clean --force;

COPY ./ /app

EXPOSE 4200

CMD ["npm", "run", "start"]
