FROM balenalib/raspberry-pi-node:11.15.0-20190507

RUN [ "cross-build-start" ]

ENV LANG C.UTF-8

RUN npm install triplesec && npm cache clean --force;
RUN npm install readline-sync && npm cache clean --force;

RUN useradd -ms /bin/bash node

RUN [ "cross-build-end" ]

USER node
WORKDIR /home/node
