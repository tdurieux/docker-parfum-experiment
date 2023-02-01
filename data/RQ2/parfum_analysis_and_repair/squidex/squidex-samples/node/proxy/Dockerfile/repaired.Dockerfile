FROM node:15

ENV NODE_ENV=production

RUN npm i --g typescript && npm cache clean --force;

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm i --production=false && npm cache clean --force;

COPY . .

RUN npm run build

CMD [ "node", "dist/app.js" ]