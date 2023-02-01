FROM node:12-alpine

COPY . /app
WORKDIR /app

RUN npm install && npm cache clean --force;

ENTRYPOINT ["node", "cli.js"]
CMD ["--help"]
