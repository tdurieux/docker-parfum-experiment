FROM node:13

WORKDIR /usr/src/app

COPY package.json ./

COPY ../../config.ts ../../

RUN npm i && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD ["npm", "start"]