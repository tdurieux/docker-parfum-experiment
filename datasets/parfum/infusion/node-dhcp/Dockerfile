FROM node:14

WORKDIR /usr/src/app

COPY . .

RUN npm install
RUN npm link

EXPOSE 67/udp

CMD [ "node", "examples/server.js" ]
