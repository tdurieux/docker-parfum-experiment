FROM nodesource/node:4.2

ADD package.json package.json
RUN npm install && npm cache clean --force;
ADD . .
