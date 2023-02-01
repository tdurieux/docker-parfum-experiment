FROM node:14

WORKDIR /honeycomb

COPY package.json .

RUN npm install && npm cache clean --force;

COPY . .

CMD ["node", "docker-start.js"]
