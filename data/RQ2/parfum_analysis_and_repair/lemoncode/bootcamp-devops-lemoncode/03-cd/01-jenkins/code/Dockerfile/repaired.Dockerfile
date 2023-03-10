FROM node:alpine3.12 as builder

WORKDIR /build

COPY . .

RUN npm install && npm cache clean --force;

RUN npm run build

FROM node:alpine3.12 as application

WORKDIR /opt/app

COPY package.json .

COPY package-lock.json .

COPY --from=builder /build/app .

RUN npm i --only=production && npm cache clean --force;

CMD ["node", "app.js"]