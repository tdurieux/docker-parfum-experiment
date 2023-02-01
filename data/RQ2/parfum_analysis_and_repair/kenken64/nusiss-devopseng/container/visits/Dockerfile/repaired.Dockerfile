FROM node:alpine

WORKDIR '/app'

COPY package.json .
run npm install && npm cache clean --force;
COPY . .

CMD ["npm", "start"]