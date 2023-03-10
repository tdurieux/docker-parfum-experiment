FROM node:10.16.0

WORKDIR /app

COPY ./package.json ./
RUN npm i && npm cache clean --force;
COPY . .

EXPOSE 3000

CMD npm run development
