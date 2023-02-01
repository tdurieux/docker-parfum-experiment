FROM node:16-alpine

WORKDIR /service

COPY package.json ./
COPY server ./server
COPY public ./public

RUN npm i && npm cache clean --force;
USER node

CMD ["npm", "run", "start:server"]
