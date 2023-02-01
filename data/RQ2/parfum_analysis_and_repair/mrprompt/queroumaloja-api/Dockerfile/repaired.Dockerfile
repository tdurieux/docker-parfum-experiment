FROM node:alpine

ENV HOME=/home/app

WORKDIR ${HOME}

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
  && pip install --no-cache-dir virtualenv \
  && rm -rf /var/cache/apk/*

COPY package.json package-lock.json ${HOME}/

RUN npm install --progress=false --quiet && npm cache clean --force;

COPY . ${HOME}

EXPOSE 8080

CMD [ "node", "server.js" ]
