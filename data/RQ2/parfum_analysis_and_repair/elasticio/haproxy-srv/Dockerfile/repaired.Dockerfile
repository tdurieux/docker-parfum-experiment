FROM mhart/alpine-node:5

RUN apk add --no-cache --update haproxy

COPY package.json /src/

RUN cd /src; npm install && npm cache clean --force;

COPY start.js haproxy.cfg.template /src/

CMD ["node", "/src/start.js"]