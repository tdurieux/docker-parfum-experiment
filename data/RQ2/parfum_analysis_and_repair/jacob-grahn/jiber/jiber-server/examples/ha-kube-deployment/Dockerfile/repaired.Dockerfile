FROM node:12-alpine
COPY . /app
WORKDIR /app
RUN npm i && npm cache clean --force;
CMD node index.js