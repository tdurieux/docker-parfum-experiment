FROM node:14

WORKDIR /usr/src/app
COPY . .

RUN npm i && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]
