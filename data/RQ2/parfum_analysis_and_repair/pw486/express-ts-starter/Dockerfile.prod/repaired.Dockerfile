FROM node:dubnium-alpine AS builder
WORKDIR /app

COPY . ./
RUN npm install && npm cache clean --force;
RUN npm run build

FROM keymetrics/pm2:10-alpine
WORKDIR /app

COPY package.json ecosystem.config.js ormconfig.js tsconfig.json tsconfig-paths-bootstrap.js .env ./
COPY --from=builder /app/dist ./dist

RUN npm install --production && npm cache clean --force;
RUN pm2 install pm2-logrotate
RUN pm2 set pm2-logrotate:compress true
RUN pm2 set pm2-logrotate:max_size 50M
RUN npm cache clean --force

CMD [ "pm2-runtime", "start", "ecosystem.config.js" ]
EXPOSE 3000
