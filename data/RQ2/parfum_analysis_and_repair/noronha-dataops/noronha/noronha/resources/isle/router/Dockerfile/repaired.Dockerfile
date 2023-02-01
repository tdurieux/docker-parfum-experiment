FROM node

ADD package.json .

RUN npm install && npm cache clean --force;

RUN mkdir -p /logs

ADD router.js .

ENTRYPOINT ["node", "router.js"]
