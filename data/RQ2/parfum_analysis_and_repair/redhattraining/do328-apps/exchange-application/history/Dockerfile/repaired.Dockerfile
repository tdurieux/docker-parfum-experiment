FROM ubi8/nodejs-12

COPY package.json .

RUN npm install && npm cache clean --force;

COPY lib ./lib
COPY index.js .

CMD node index.js
