FROM node:16

ADD . /app
WORKDIR /app

EXPOSE 8000

RUN npm install pm2 -g && npm cache clean --force;
RUN npm ci
CMD ["pm2-runtime", "api.js"]
