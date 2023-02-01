FROM node:10

COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

ENTRYPOINT [ "node", "/dist/index.js" ]