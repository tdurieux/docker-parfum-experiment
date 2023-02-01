FROM node:5.11.0-slim

WORKDIR /app

RUN npm install -g nodemon && npm cache clean --force;
ADD package.json /app/package.json
RUN npm config set registry http://registry.npmjs.org
RUN npm install && npm ls && npm cache clean --force;
RUN mv /app/node_modules /node_modules

ADD . /app

EXPOSE 80
ENV PORT 80

CMD ["node", "server.js"]
