from node:16-alpine

WORKDIR /usr/src/app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY inventory.js .
COPY inventory.graphql .

CMD [ "node", "inventory.js" ]
