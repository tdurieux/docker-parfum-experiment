FROM node:10-alpine

WORKDIR /app

COPY . /app

RUN npm install && npm cache clean --force;

ENTRYPOINT ["node", "bin/cli.js"]

CMD ["--help"]
