FROM node:current-alpine

RUN npm install --global bash-language-server && npm cache clean --force;

ENTRYPOINT ["/usr/local/bin/bash-language-server"]
