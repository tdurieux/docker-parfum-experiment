FROM mhart/alpine-node:7.10.1

WORKDIR /srv
ADD . .
RUN npm install && npm cache clean --force;

EXPOSE 8081
CMD ["node", "server.js"]
