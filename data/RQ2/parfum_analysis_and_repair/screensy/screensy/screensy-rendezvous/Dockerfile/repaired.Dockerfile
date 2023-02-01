FROM node:14.16-alpine3.13 AS builder

WORKDIR /home/node/app

COPY tsconfig.json ./
COPY server.ts ./

COPY package.json ./
COPY package-lock.json ./

RUN npm install --only=development && npm cache clean --force;
RUN npx tsc

FROM node:14.16-alpine3.13

COPY --from=builder /home/node/app/server.js ./
COPY --from=builder /home/node/app/server.js.map ./
COPY --from=builder /home/node/app/server.ts ./

COPY package.json ./
COPY package-lock.json ./

RUN npm install --only=production && npm cache clean --force;

USER node

CMD ["npm", "start"]
