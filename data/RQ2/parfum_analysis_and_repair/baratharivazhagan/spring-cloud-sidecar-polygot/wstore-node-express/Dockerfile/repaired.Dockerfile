FROM node:14-alpine

WORKDIR /usr/wstore-node-express

COPY package.json .


RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]