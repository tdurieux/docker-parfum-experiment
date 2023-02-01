FROM node:10.16.2-alpine

RUN npm install -g humblebundle-ebook-downloader --unsafe-perm=true && npm cache clean --force;

ENTRYPOINT ["humblebundle-ebook-downloader"]
