{{#amd64}}
FROM node:11.15.0-stretch
{{/amd64}}

{{#arm32v6}}
FROM balenalib/raspberry-pi-node:11.15.0-20190507
{{/arm32v6}}

{{#cross}}
RUN [ "cross-build-start" ]
{{/cross}}

ENV LANG C.UTF-8

RUN npm install triplesec && npm cache clean --force;
RUN npm install readline-sync && npm cache clean --force;

{{#arm32v6}}
RUN useradd -ms /bin/bash node
{{/arm32v6}}

{{#cross}}
RUN [ "cross-build-end" ]
{{/cross}}

USER node
WORKDIR /home/node
