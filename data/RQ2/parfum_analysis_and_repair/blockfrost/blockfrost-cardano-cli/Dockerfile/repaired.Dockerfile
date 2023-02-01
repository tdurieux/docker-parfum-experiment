FROM node:16-alpine

WORKDIR /app

RUN npm install -g @blockfrost/blockfrost-cardano-cli && npm cache clean --force;

ENTRYPOINT ["/usr/local/bin/bcc"]
