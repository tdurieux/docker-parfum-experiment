FROM yobasystems/alpine-mariadb:latest

RUN apk add --no-cache tzdata
COPY . /scripts
RUN chmod -R 755 /scripts

ENTRYPOINT ["/scripts/entrypoint.sh"]