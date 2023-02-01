from node:16-alpine

WORKDIR /usr/src/app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY products.js .
COPY products.graphql .

CMD [ "node", "products.js" ]
