FROM node

WORKDIR /app

COPY ./package.json ./package-lock.json ./

RUN npm i && npm cache clean --force;

COPY . .

CMD npm run start

