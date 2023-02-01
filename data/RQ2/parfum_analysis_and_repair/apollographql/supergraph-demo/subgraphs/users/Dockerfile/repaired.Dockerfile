from node:16-alpine

WORKDIR /usr/src/app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY users.js .
COPY users.graphql .

CMD [ "node", "users.js" ]
