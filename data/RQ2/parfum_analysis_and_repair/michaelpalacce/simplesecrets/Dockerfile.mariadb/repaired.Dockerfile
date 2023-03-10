FROM node:gallium-slim

WORKDIR /app

COPY . .

RUN apt update -y && \
    npm uninstall --save sqlite3 &&  \
    npm i --save mariadb@3.0 &&  \
    npm i &&  \
    npm rebuild &&  \
    npm run build && \
    npm prune --production && \
    rm -rf api charts mocks index.ts &&  \
    cp -R dist/* /app && \
    apt autoremove -y && npm cache clean --force;

ENV APP_PORT=3000
ENV PROD_DB_USERNAME="simplesecrets"
ENV PROD_DB_PASSWORD="simplesecrets"
ENV PROD_DB_NAME="simplesecrets"
ENV PROD_DB_HOSTNAME="mariadb"
ENV PROD_DB_PORT="3306"
ENV PROD_DB_DIALECT="mariadb"

CMD [ "node", "index.js" ]
