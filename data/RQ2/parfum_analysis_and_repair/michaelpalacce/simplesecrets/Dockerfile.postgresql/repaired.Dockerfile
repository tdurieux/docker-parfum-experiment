FROM node:gallium-slim

WORKDIR /app

COPY . .

RUN apt update -y && \
    npm uninstall --save sqlite3 &&  \
    npm i --save pg@8.7 &&  \
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
ENV PROD_DB_HOSTNAME="postgresql"
ENV PROD_DB_PORT="5432"
ENV PROD_DB_DIALECT="postgres"

CMD [ "node", "index.js" ]
