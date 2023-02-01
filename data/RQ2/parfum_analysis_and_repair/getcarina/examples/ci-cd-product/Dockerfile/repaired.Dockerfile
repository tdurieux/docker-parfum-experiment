FROM node:0.10-onbuild

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src

RUN apt-get update && apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install restify && npm cache clean --force;
RUN npm install request && npm cache clean --force;

COPY productws.js productws.js

EXPOSE 8080

ENTRYPOINT node productws.js
