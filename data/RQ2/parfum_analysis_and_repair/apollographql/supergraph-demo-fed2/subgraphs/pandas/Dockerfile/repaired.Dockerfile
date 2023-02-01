FROM node:18-bullseye

WORKDIR /usr/src/app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY pandas.js .
COPY pandas.graphql .

CMD [ "node", "pandas.js" ]
