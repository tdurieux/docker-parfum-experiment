FROM mhart/alpine-node:7.4.0

WORKDIR /srv
ADD . .
RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD ["node", "server.js"]
