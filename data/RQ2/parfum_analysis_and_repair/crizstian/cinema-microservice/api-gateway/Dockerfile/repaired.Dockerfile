FROM node:7.5.0-alpine

ENV HOME=/home/nupp

COPY package.json npm-shrinkwrap.json $HOME/app/

COPY src/ $HOME/app/src

ADD https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64 /usr/local/bin/dumb-init

WORKDIR $HOME/app

RUN chmod +x /usr/local/bin/dumb-init && \
    npm cache clean --force && \
    npm install --silent --progress=false --production && npm cache clean --force;

CMD ["dumb-init", "npm", "start"]
