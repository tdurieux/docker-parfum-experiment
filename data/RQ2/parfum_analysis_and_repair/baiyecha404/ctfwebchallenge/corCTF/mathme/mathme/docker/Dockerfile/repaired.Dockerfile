FROM node:14-alpine

WORKDIR /code

COPY code/ /code

RUN npm i && npm cache clean --force;

CMD ["node", "index.js"]