FROM node:alpine

COPY ./ /usr/src

WORKDIR /usr/src

RUN npm i -g pm2 && \
    npm i && npm cache clean --force;

EXPOSE 3000

CMD ["pm2", "start", "server/index.js", "--no-daemon"]
