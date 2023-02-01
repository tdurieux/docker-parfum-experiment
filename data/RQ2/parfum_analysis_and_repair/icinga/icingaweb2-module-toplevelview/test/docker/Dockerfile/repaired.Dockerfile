FROM lazyfrosch/icingaweb2

RUN apk add --no-cache -U \
    php7-pdo_sqlite \
    sqlite
