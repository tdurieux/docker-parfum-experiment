FROM node:latest

WORKDIR /app

COPY package.json .
RUN npm install && npm cache clean --force;
COPY index.js .

ENV DEBUG=pyroscope
CMD ["node", "index.js"]
