# Setup development environment for Proof of Existence
FROM node:carbon
LABEL maintainer="Clement Renaud <clement@poex.io>, \
Fengling Qin <qinfengling@poex.io>"

ENV NPM_CONFIG_LOGLEVEL info

RUN apt-get update && \
    apt-get install --no-install-recommends -y vim && \
            apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /app

COPY package.json /app
RUN npm install && npm cache clean --force;
RUN npm install bcrypt && npm cache clean --force;

COPY . /app

RUN cp config/test.yaml config/local-development.yaml && \
    npm run build
CMD npm start
