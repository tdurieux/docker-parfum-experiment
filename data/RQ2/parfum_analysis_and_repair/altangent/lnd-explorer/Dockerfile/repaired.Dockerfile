FROM node:alpine

COPY . /lnd-explorer

WORKDIR /lnd-explorer

RUN npm install \
&& npm run build && npm cache clean --force;

CMD npm start
