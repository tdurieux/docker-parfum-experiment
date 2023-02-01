FROM node:12.18.3 as builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENV NODE_ENV production

RUN npm run-script build

FROM node:12.18.3

WORKDIR /usr/src/app

ENV NODE_ENV production

COPY --from=builder /usr/src/app/build ./build/
COPY --from=builder /usr/src/app/config ./config/
COPY --from=builder /usr/src/app/*.json ./
RUN npm install --production && npm cache clean --force;

EXPOSE 8080

CMD [ "npm", "start" ]
