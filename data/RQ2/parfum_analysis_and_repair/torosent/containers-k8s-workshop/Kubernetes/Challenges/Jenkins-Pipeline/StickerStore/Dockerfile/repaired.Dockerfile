FROM node:8.6.0

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

EXPOSE 80
CMD [ "node", "index.js" ]
