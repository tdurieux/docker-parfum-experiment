FROM node:10.9-alpine

COPY . /app
WORKDIR /app

RUN npm install && \
    npm run build && \
    npm prune --production && npm cache clean --force;

EXPOSE 8080

ENTRYPOINT ["./docker/entrypoint.sh"]
