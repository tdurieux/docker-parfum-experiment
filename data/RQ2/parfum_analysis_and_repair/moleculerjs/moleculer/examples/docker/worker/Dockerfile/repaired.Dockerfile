FROM node:8-alpine

RUN mkdir /app
WORKDIR /app

COPY package.json .

ENV NODE_ENV=production

RUN npm install --production && npm cache clean --force;

COPY moleculer.config.js service.js ./

EXPOSE 4445
EXPOSE 9229

CMD ["npm", "start"]
