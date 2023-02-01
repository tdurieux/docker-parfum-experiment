FROM node:6.5.0

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
COPY . /usr/src/app
RUN export NODE_ENV=production
RUN npm install && npm cache clean --force;
RUN npm install pm2 -g && npm cache clean --force;

EXPOSE 3100

# Run using PM2 process manager in clustered mode with monitoring
CMD pm2 start app/bin/www -i 0 --name production-example-web && pm2 monit