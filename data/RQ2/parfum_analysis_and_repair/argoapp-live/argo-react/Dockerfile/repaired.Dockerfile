FROM node:12

WORKDIR /app

COPY . ./

RUN npm install -g serve && npm cache clean --force;

RUN npm install && npm cache clean --force;

RUN npm run build

CMD [ "serve", "-s", "build", "-l", "3000" ]