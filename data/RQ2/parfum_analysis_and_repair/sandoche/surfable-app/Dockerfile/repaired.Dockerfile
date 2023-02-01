FROM node:14

ARG PM2_PUBLIC_KEY=${PM2_PUBLIC_KEY}
ARG PM2_SECRET_KEY=${PM2_SECRET_KEY}

WORKDIR /usr/src/app

COPY . .

RUN npm install pm2 -g && npm cache clean --force;

ENV PM2_PUBLIC_KEY $PM2_PUBLIC_KEY
ENV PM2_SECRET_KEY $PM2_SECRET_KEY

RUN npm install && npm cache clean --force;
RUN npm run build

CMD ["pm2-runtime", "ecosystem.config.js"]
