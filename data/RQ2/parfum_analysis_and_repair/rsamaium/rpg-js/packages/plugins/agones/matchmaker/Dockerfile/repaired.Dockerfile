FROM node:16-alpine
WORKDIR /app
ADD . /app
RUN npm i && npm cache clean --force;
RUN npm run build
CMD node dist/server.js