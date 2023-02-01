FROM node:16.15.0-alpine as builder

WORKDIR /usr/src/app

COPY . .

RUN npm install && npm cache clean --force;

RUN npm run build

FROM node:16.15.0-alpine as production

WORKDIR /usr/src/app

COPY ./package.json ./

RUN npm install --only=production && npm cache clean --force;

COPY --from=builder /usr/src/app/dist ./dist

CMD ["node", "dist/main"]