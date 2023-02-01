FROM node:14

RUN mkdir /app
WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY index.js .

CMD ["node", "index.js"]
