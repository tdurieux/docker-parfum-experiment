FROM node:12

COPY index.js .
COPY package.json .

RUN npm install && npm cache clean --force;

CMD [ "node", "index.js" ]
