FROM node:10.16.0

WORKDIR /app

COPY ./package.json ./
RUN npm i -s && npm cache clean --force;
COPY . .
RUN npm run build

EXPOSE 3000

CMD npm start
