FROM node:alpine
COPY . /app
WORKDIR /app

RUN mkdir -p logs && \
    npm install && \
    npm install pm2 -g && \
    npm run prod && npm cache clean --force;

EXPOSE 3200
CMD npm run serve && pm2 logs
