FROM node:12-alpine

WORKDIR /app

ADD . .

RUN npm install -g . && npm cache clean --force;

ENTRYPOINT ["yarrrml-parser"]
CMD ["-h"]
