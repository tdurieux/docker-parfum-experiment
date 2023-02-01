FROM node:15.2.0-alpine3.12

RUN npm install --global gulp-cli

COPY entrypoint.sh /entrypoint.sh
WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
