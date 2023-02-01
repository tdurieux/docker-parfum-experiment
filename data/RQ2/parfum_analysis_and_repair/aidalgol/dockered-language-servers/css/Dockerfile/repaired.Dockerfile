FROM node:current-alpine

RUN npm install -g vscode-css-languageserver-bin && npm cache clean --force;

ENTRYPOINT ["/usr/local/bin/css-languageserver"]
