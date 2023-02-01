FROM node

WORKDIR /app

COPY src/js/* ./

RUN npm install && npm cache clean --force;

CMD ["node", "server.js"]
