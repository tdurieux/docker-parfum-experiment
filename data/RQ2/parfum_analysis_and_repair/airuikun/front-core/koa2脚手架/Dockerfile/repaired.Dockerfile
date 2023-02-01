FROM node:6.3.0

MAINTAINER superalsrk "https://github.com/superalsrk"

RUN mkdir -p /var/app

WORKDIR /var/app

COPY . /var/app/

RUN npm install && npm cache clean --force;

RUN npm run build

RUN npm install -g pm2 && npm cache clean --force;

ENV NODE_ENV production

EXPOSE 5000

# USER nobody
WORKDIR /var/app

CMD ["pm2", "start", "start.js", "--no-daemon"]