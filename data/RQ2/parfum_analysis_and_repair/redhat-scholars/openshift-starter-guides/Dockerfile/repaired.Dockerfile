FROM node:latest

RUN mkdir -p /opt/src

WORKDIR /opt/src

ADD . /opt/src

RUN chgrp -R 0 /opt/src && \
    chmod -R g=u /opt/src

RUN npm install && npm cache clean --force;

CMD npm run dev -d
